#!/bin/bash

# path to token
token=$(cat "$1")
zone_name="$2"
# ip address, or empty to get from https://icanhazip.com
old_content="0.0.0.0"
new_content="0.0.0.0"
# todo if no content then get from somewhere

get() {
  curl -sS -X GET "https://api.cloudflare.com/client/v4/$1" -H "Authorization: Bearer $token" -H "Content-Type:application/json"
}

zone_id=$(get "zones" \
  | jq -r '.result[]| select(.name == "'"$zone_name"'").id')

if [ -z "$zone_id" ]; then
  echo "Zone id for zone_name $zone_name not found"
  exit 1
fi;
echo "Found zone id $zone_id for zone_name $zone_name"

dns_ids=$(get "zones/$zone_id/dns_records" \
  | jq -r '.result[]| select(.content == "'"$old_content"'").id')

if [ -z "$dns_ids" ]; then
  echo "No dns records to update"
  exit 0
fi;

while IFS= read -r dns_id; do
  echo "Updating dns_id $dns_id"
  response=$(curl -sS -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_id" -H "Authorization: Bearer $token" -H "Content-Type:application/json" \
               --data '{"content":"'"$new_content"'"}')
  if [ "$(echo "$response" | jq '.success')" != "true" ]; then
    echo "Error"
    echo "$response"
    exit 1
  fi;
  echo "Success"
done <<< "$dns_ids"
