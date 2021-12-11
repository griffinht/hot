#!/bin/bash

CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
ZONE_ID="$2"
DNS_IDS="$3"
CONTENT="$4"

# iterate through $DNS_IDS
while IFS= read -r DNS_ID; do
  echo "Updating DNS_ID $DNS_ID"

  RESPONSE=$(curl -sS -X PATCH \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json" \
       --data '{"content":"'"$CONTENT"'"}') \
      "$CLOUDFLARE_API_URL""zones/$ZONE_ID/dns_records/$DNS_ID"

  if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$RESPONSE" | jq '.error'
    exit 1
  fi;

  echo "Success"
done <<< "$DNS_IDS"