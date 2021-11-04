#!/usr/bin/evn bash

npm ci --silent
npm run build --silent
TEST_RESULT=$(npm run test --silent 2>&1 | tail -5 | tr -s "\n" " " | tr -s "\" " " ")
TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)

UNIQUE="VictorMarty11"

SEARCH_TASK=$(
  curl --location --request POST "https://api.tracker.yandex.net/v2/issues/_search" \
  --header 'Authorization: OAuth '"$TOKEN" \
  --header 'X-Org-ID: '"$ORG_ID" \
  --header 'Content-Type: application/json' \
  --data-raw '{"filter":{"unique":"'"$UNIQUE"''"$TAG_ACTUAL"'"}}'
  )

TASK_ID=$(echo "$SEARCH_TASK" | jq '.[0].key')
# TASK_ID=$(echo "$SEARCH_TASK" | jq -r ".[0].id")
# DESCRIPTION1=$(echo "$SEARCH_TASK" | jq -r ".[0].description")
DESCRIPTION1="test yu"
echo "SEARCH_TASK $SEARCH_TASK"
echo "DESCRIPTION1 $DESCRIPTION1"
echo "TASK_ID $TASK_ID"
# DESCRIPTION=$(echo "$DESCRIPTION1" | sed -z 's/\n/\\n/g')
# NEW_DESCRIPTION="$DESCRIPTION""\n ""\n ""TEST RESULT:""$TEST_RESULT"
# echo "DESCRIPTION $NEW_DESCRIPTION"
# SUMMARY=$(echo "$SEARCH_TASK" | jq -r ".[0].summary" |  sed -z 's/\n/\\n/g')
echo "SUMMARY $SUMMARY"
NEW_DATA='{
  "queue": "TMP",
  "summary": "summary yu",
  "description": "description yu",
  "unique": "'"$UNIQUE"''"$TAG_ACTUAL"'"
}'

UPDATE_TASK=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request PATCH https://api.tracker.yandex.net/v2/issues/6183e3d5ac3a9529257e5dc5 \
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