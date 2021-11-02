#! /bin/bash

TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)
UNIQUE="VictorMarty11"

sudo docker build -t release:"$TAG_ACTUAL" .



if [ $? = 0 ]; then
  echo "Docker created successfully"

COMMENT="Docker: release:$TAG_ACTUAL"
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
    curl  -s -o dev/null -w '%{http_code}' -X POST https://api.tracker.yandex.net/v2/issues/$TASK_ID/comments \
    -H "Content-Type: application/json" \
    -H "Authorization: OAuth $TOKEN" \
    -H "X-Org-Id: $ORG_ID" \
    -d '{
        "text":"'"$COMMENT"'"
    }')
if [ "$ADD_COMMENT" = "201" ]
then
      echo "Comment added"
    fi

else
  echo "Docker-image wasn't created"
  exit 1
fi