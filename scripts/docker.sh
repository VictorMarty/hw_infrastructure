#! /bin/bash
TAG_ACTUAL=$(git tag --sort version:refname | tail -1 | head -n1)
UNIQUE="VictorMarty11"

sudo docker build -t release:"$TAG_ACTUAL" .

if [ $? = 0 ]; then
  MESSAGE="Docker created successfully"
  echo "Docker created successfully"
else
  MESSAGE="Docker-image wasn't created "
  echo "Docker-image wasn't created"
fi

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

COMMENT="Docker: release:$TAG_ACTUAL"

TASK_ID=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].id")
DESCRIPTION=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].description")
SUMMARY=$(echo "$SEARCH_TASK"  | tr '\r\n' ' ' | jq -r ".[0].summary" |  sed -z 's/\n/\\n/g')
DESCRIPTION=$(echo "$DESCRIPTION"  |  sed -z 's/\n/\\n/g')
NEW_DESCRIPTION="$DESCRIPTION""\n ""\n ""$COMMENT"" ""\n ""$MESSAGE"
echo "$NEW_DESCRIPTION"

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
  echo "Comment added"
else
	echo "Can't added comment adout Docker"
fi
