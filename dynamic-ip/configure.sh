#!/bin/bash
# cli tool to get $DNS_IDS from $ZONE_ID and $CONTENT and save to file for docker-compose
CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
CONTENT="$2"

rm -f dynamic-ip/paths

for ZONE_ID in "${@:3}"; do
  echo "Doing $ZONE_ID"
  # todo read -p
  if [ -z "$CLOUDFLARE_API_TOKEN" ]; then printf "Specify a CLOUDFLARE_API_TOKEN - go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token\nToken name: hot_dynamic-ip\nPermissions: Zone, DNS, Read/Edit (and edit for cloudflare-dynamic.sh)\nContinue to summary > Create Token > (pass given token as first argument)\n"; exit 1; fi
  if [ -z "$ZONE_ID" ]; then printf "Specify a ZONE_ID - go to Cloudflare dashboard > (your domain) > Overview > API > Zone ID\n"; exit 1; fi
  if [ -z "$CONTENT" ]; then printf "Specify a CONTENT - current IP address of the DNS records you want to select to keep updated, e.g. 123.123.123.123)\n"; exit 1; fi

  RESPONSE=$(curl -sS -X GET \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json" \
      "$CLOUDFLARE_API_URL""zones/$ZONE_ID/dns_records")

  if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$RESPONSE" | jq
    exit 1
  fi;

  PATHS="$(echo "$RESPONSE" | jq -r '.result[]| select(.content == "'"$CONTENT"'").id')"
  while IFS= read -r P; do
    echo "Adding $P"
    echo "zones/$ZONE_ID/dns_records/$P" >> dynamic-ip/paths
  done <<< "$PATHS"
  echo "$CLOUDFLARE_API_TOKEN" > bin/dynamic-ip_cloudflare

  echo "Success! Saved token to bin/dynamic-ip_cloudflare and dynamic-ip/paths to file"
  cat dynamic-ip/paths
done
