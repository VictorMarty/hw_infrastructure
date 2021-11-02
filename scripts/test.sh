#! /bin/bash

npm ci --silent
npm run build --silent
TEST_RESULT=$(npm run test 2>&1 | tr "\\\\\\\\" "/"| tr -s "\n" " ")
TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)

UNIQUE="VictorMarty11"

#TEST_RESULT="TEST"
testResult=$(npm run test 2>&1 | tr "\\\\\\\\" "/"| tr -s "\n" " ")

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

    comment=$(
    curl  -s -o dev/null -w '%{http_code}' -X POST https://api.tracker.yandex.net/v2/issues/$TASK_ID/comments \
    -H "Content-Type: application/json" \
    -H "Authorization: OAuth $TOKEN" \
    -H "X-Org-Id: $ORG_ID" \
    -d '{
        "text":"'"$testResult"'"
    }')

echo "$ADD_COMMENT"