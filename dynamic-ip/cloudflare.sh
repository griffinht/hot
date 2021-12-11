#!/bin/bash
# PATCH zones/$ZONE_ID/dns_records/$PATHS with $CONTENT
CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
PATHS="$2"
CONTENT="$3"

# iterate through $PATHS
while IFS= read -r ID; do
  echo "Updating $ID"

  RESPONSE=$(curl -sS -X PATCH \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json" \
       --data '{"content":"'"$CONTENT"'"}' \
      "$CLOUDFLARE_API_URL$ID")

  if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$RESPONSE"
    exit 1
  fi;

  echo "Success"
done <<< "$PATHS"