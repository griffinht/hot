#!/bin/bash
set -e

ZONE_NAME="$1"
IP_SERVER="https://icanhazip.com"
#OLD_CONTENT_FILE="old_ip_address"
OLD_CONTENT_FILE="/cloudflare-dynamic/old_ip_address"

# path to CLOUDFLARE_API_TOKEN
CLOUDFLARE_API_TOKEN=$(cat "/run/secrets/cloudflare-dynamic_cloudflare")
#CLOUDFLARE_API_TOKEN=$(cat "$1")
#ZONE_NAME="$2"
# new ip address, or empty to get from $IP_SERVER via simple curl request
# this will replace any occurrences of $OLD_CONTENT in dns records
NEW_CONTENT="$3"
# old ip address, or empty to get from file
OLD_CONTENT="$4"

if [ -z "$NEW_CONTENT" ]; then
  # get $NEW_CONTENT from $IP_SERVER
  NEW_CONTENT=$(curl -sS $IP_SERVER)
  echo "Got current ip address $NEW_CONTENT from $IP_SERVER"
fi;

if [ -z "$OLD_CONTENT" ]; then
  # get $OLD_CONTENT from file
  if [ -f "$OLD_CONTENT_FILE" ]; then
    OLD_CONTENT=$(cat "$OLD_CONTENT_FILE")
  fi;

  if [ -z "$OLD_CONTENT" ]; then
    # get $OLD_CONTENT from $NEW_CONTENT
    OLD_CONTENT=$NEW_CONTENT
    echo "Got old ip address from current ip address $NEW_CONTENT, saving to file"
    echo "$OLD_CONTENT" > "$OLD_CONTENT_FILE"
  else
    echo "Got old ip address $OLD_CONTENT from file $OLD_CONTENT_FILE"
  fi;
fi;

# check if update is needed
if [ "$OLD_CONTENT" == "$NEW_CONTENT" ]; then
  echo "IP address change not detected, still $OLD_CONTENT"
  exit 0
fi;

echo "IP address change detected, updating occurrences of $OLD_CONTENT to $NEW_CONTENT"

get() {
  curl -sS -X GET "https://api.cloudflare.com/client/v4/$1" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json"
}

# get $ZONE_ID from $ZONE_NAME
ZONE_ID=$(get "zones" \
  | jq -r '.result[]| select(.name == "'"$ZONE_NAME"'").id')

if [ -z "$ZONE_ID" ]; then
  echo "Zone id for ZONE_NAME $ZONE_NAME not found"
  exit 1
fi;
echo "Found zone id $ZONE_ID for ZONE_NAME $ZONE_NAME"

# get $DNS_IDS from $ZONE_ID
DNS_IDS=$(get "zones/$ZONE_ID/dns_records" \
  | jq -r '.result[]| select(.content == "'"$OLD_CONTENT"'").id')

if [ -z "$DNS_IDS" ]; then
  echo "Warning: couldn't find any dns records with content $OLD_CONTENT to update to $NEW_CONTENT"
  exit 1
fi;

# iterate through $DNS_IDS
# entries with content that match $OLD_CONTENT will be updated to $NEW_CONTENT
while IFS= read -r DNS_ID; do
  echo "Updating DNS_ID $DNS_ID"
  RESPONSE=$(curl -sS -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_ID" -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type:application/json" \
               --data '{"content":"'"$NEW_CONTENT"'"}')
  if [ "$(echo "$RESPONSE" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$RESPONSE"
    exit 1
  fi;
  echo "Success"
done <<< "$DNS_IDS"

echo "$NEW_CONTENT" > "$OLD_CONTENT_FILE"
echo "Persisted $NEW_CONTENT to file $OLD_CONTENT_FILE"