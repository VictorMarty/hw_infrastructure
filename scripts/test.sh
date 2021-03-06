#!/usr/bin/evn bash

npm ci --silent
npm run build --silent
TEST_RESULT=$(npm run test --silent 2>&1 | tail -5 | tr -s "\n" " " | tr -s "\" " " ")
TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)

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

TASK_ID=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].id")
DESCRIPTION=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].description")
NEW_DESCRIPTION="$DESCRIPTION""\n ""\n ""TEST RESULT:""$TEST_RESULT"
SUMMARY=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].summary" |  sed -z 's/\n/\\n/g')

NEW_DATA='{
  "queue": "TMP",
  "summary": "'${SUMMARY}'",
  "description": "'${NEW_DESCRIPTION}'",
  "unique": "'"$UNIQUE"''"$TAG_ACTUAL"'"
}'

UPDATE_TASK=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request PATCH https://api.tracker.yandex.net/v2/issues/${TASK_ID}/ \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data-raw "$NEW_DATA"
  )

echo "$UPDATE_TASK"
if [ "$UPDATE_TASK" = "200" ]
then
  echo "Information about test result added"
else
  echo "Can't add test information to task"
fi