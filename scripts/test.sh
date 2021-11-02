#!/usr/bin/evn bash

npm ci --silent
npm run build --silent
TEST_RESULT=$(npm test | tail -n +3)

echo "{\"text\": \"$(echo $TEST_RESULT| tr -d ':' | tr "\r\n" " ")\"}" | jq > tmp.json

TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)


HOST="https://api.tracker.yandex.net/v2/issues/"
UNIQUE="VictorMarty11"

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
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "https://api.tracker.yandex.net/v2/issues/${TASK_ID}/comments" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data-binary @tmp.json
  )
  echo "$ADD_COMMENT"
  rm tmp.json




