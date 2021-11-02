#!/usr/bin/evn bash

npm ci --silent
npm run build --silent
TEST_RESULTT=$(npx jest --silent 2>&1 | tail -5 | tr -s ":" " " | tr -s "\n" " " )
TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)

UNIQUE="VictorMarty11"

TEST_RESULT="TEST"


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

  ADD_COMMENT=$(
    curl -so dev/null -w '%{http_code}' -X POST "https://api.tracker.yandex.net/v2/issues/"$TASK_ID"/comments" \
    --header 'Authorization: OAuth '"$TOKEN" \
    --header 'X-Org-ID: '"$ORG_ID" \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "text": "'"$TEST_RESULT"'"
  }'
)

echo "$ADD_COMMENT"