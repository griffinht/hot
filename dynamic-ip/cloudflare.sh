#!/bin/bash
# PATCH zones/$ZONE_ID/dns_records/$IDS with $CONTENT
CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
IDS="$3"
CONTENT="$4"

# iterate through $IDS
while IFS= read -r IDS; do
  echo "Updating IDS $IDS"

  RESPONSE=$(curl -sS -X PATCH \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json" \
       --data '{"content":"'"$CONTENT"'"}' \
      "$CLOUDFLARE_API_URL$IDS")

  if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$RESPONSE"
    exit 1
  fi;

  echo "Success"
done <<< "$IDS"