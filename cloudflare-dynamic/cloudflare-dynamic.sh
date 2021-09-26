#!/bin/bash

ip_server="https://icanhazip.com"
old_content_file="old_ip_address"

# path to token
token=$(cat "$1")
zone_name="$2"
# old ip address, or empty to get from file
old_content="$3"
# new ip address, or empty to get from $ip_server via simple curl request
# this will replace any occurrences of $old_content in dns records
new_content="$4"

if [ -z "$new_content" ]; then
  # get $new_content from $ip_server
  new_content=$(curl -sS $ip_server)
  echo "Got current ip address $new_content from $ip_server"
fi;

if [ -z "$old_content" ]; then
  # get $old_content from file
  old_content=$(cat "$old_content_file" 2>/dev/null)

  if [ -z "$old_content" ]; then
    # get $old_content from $new_content
    old_content=$new_content
    echo "Got old ip address from current ip address $new_content, saving to file"
    echo "$old_content" > "$old_content_file"
  else
    echo "Got old ip address $old_content from file $old_content_file"
  fi;
fi;

# check if update is needed
if [ "$old_content" == "$new_content" ]; then
  echo "IP address change not detected, still $old_content"
  exit 0
fi;

echo "IP address change detected, updating occurrences of $old_content to $new_content"

get() {
  curl -sS -X GET "https://api.cloudflare.com/client/v4/$1" -H "Authorization: Bearer $token" -H "Content-Type:application/json"
}

# get $zone_id from $zone_name
zone_id=$(get "zones" \
  | jq -r '.result[]| select(.name == "'"$zone_name"'").id')

if [ -z "$zone_id" ]; then
  echo "Zone id for zone_name $zone_name not found"
  exit 1
fi;
echo "Found zone id $zone_id for zone_name $zone_name"

# get $dns_ids from $zone_id
dns_ids=$(get "zones/$zone_id/dns_records" \
  | jq -r '.result[]| select(.content == "'"$old_content"'").id')

if [ -z "$dns_ids" ]; then
  echo "Warning: couldn't find any dns records with content $old_content to update to $new_content"
  exit 1
fi;

# iterate through $dns_ids
# entries with content that match $old_content will be updated to $new_content
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
