#!/bin/bash
# cli tool to get $DNS_IDS from $ZONE_ID and $CONTENT and save to file for docker-compose
CLOUDFLARE_API_URL="https://api.cloudflare.com/client/v4/"

CLOUDFLARE_API_TOKEN="$1"
CONTENT="$2"

if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "Specify a CLOUDFLARE_API_TOKEN for dynamic-ip"
  echo "Go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token"
  echo "Token name: hot_dynamic-ip"
  echo "Permissions: Zone, DNS, Read/Edit"
  echo "Continue to summary > Create Token > (enter token below)"
  read -srp "CLOUDFLARE_API_TOKEN: " CLOUDFLARE_API_TOKEN
  echo
fi
if [ -z "$CONTENT" ]; then
  echo "Specify a CONTENT - current IP address of the DNS records you want to select to keep updated, e.g. 123.123.123.123)"
  read -rp "CONTENT: " CONTENT
fi

function zone_id() {
  ZONE_ID="$1"
  echo "Doing $ZONE_ID"

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
# todo move to env
    echo "zones/$ZONE_ID/dns_records/$P" >> dynamic-ip/paths
  done <<< "$PATHS"
  echo "DYNAMIC-IP_CLOUDFLARE=$CLOUDFLARE_API_TOKEN" >> .env

  echo "Success! Saved token to http/bin/dynamic-ip_cloudflare and dynamic-ip/paths to file"
  cat dynamic-ip/paths
}

rm -f dynamic-ip/paths

a=${@:3}
if [ -n "$a" ]; then
  for ZONE_ID in "${@:3}"; do
    zone_id "$ZONE_ID"
  done
else
  echo "Specify multiple ZONE_ID - go to Cloudflare dashboard > (your domain) > Overview > API > Zone ID"
  while read -rp "ZONE_ID: " ZONE_ID; do
    zone_id "$ZONE_ID"
  done;
fi
