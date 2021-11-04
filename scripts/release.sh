#!/usr/bin/env bash

TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)
TAG_AUTOR=$(git show "$TAG_ACTUAL" --pretty=format:"%an" --no-patch)
TAG_DATE=$(git show "$TAG_ACTUAL" --pretty=format:"%ad" --no-patch)
TAG_PREV=$(git tag | tail -2 | head -n1)
CHANGELOG=$(git log "$TAG_PREV".. --pretty=format:"%h - %s (%an, %ar)\n" | tr -s "\n" " ")
HOST="https://api.tracker.yandex.net/v2/issues/"
UNIQUE="VictorMarty11"
TITLE=$(echo "RELEASE. ""$TAG_ACTUAL"" ""$TAG_AUTOR")
TOKEN="AQAAAAAhNMz5AAd5Z0oVrHknRU78gkGFwFmhQAs"
ORG_ID="6461097"

DATA='{
  "queue": "TMP",
  "summary": "'"$TITLE"'",
  "description": "'"$CHANGELOG"'",
  "unique": "'"$UNIQUE"''"$TAG_ACTUAL"'"
}'

ADD_TASK_CODE_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "$HOST" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-Id: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data "$DATA"
)
if [ "$ADD_TASK_CODE_RESPONSE" = "201" ]
then
  echo "Task added"
fi
if [ "$ADD_TASK_CODE_RESPONSE" = "409" ]
then
  echo "Task already exist, update task"
  SEARCH_TASK=$(
  curl --location --silent --request POST "https://api.tracker.yandex.net/v2/issues/_search" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "filter": {
      "unique": "'"$UNIQUE"''"$TAG_ACTUAL"'"
    }
  }'
  )


  TASK_ID=$(echo "$SEARCH_TASK" | jq -r ".[0].id")
  UPDATE_TASK=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request PATCH "$HOST""$TASK_ID" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data "$DATA"
  )
echo "$UPDATE_TASK"
fi