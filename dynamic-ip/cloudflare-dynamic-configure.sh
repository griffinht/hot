#!/bin/bash

CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
ZONE_ID="$2"
CONTENT="$3"

if [ -z "$CLOUDFLARE_API_TOKEN" ]; then printf "Specify a CLOUDFLARE_API_TOKEN - go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token\nToken name: (any)\nPermissions: Zone, DNS, Read\nContinue to summary > Create Token > (pass given token as first argument)\n"; exit 1; fi
if [ -z "$ZONE_ID" ]; then printf "Specify a ZONE_ID - go to Cloudflare dashboard > (your domain) > Overview > API > Zone ID\n"; exit 1; fi
if [ -z "$CONTENT" ]; then printf "Specify a CONTENT - current IP address of the record you want to select, e.g. 123.123.123.123)\n"; exit 1; fi

RESPONSE=$(curl -sS -X GET \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json" \
    "$CLOUDFLARE_API_URL""zones/$ZONE_ID/dns_records")

if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
  echo "Error"
  echo "$RESPONSE" | jq
  exit 1
fi;

echo "$RESPONSE" | jq -r '.result[]| select(.content == "'"$CONTENT"'").id'