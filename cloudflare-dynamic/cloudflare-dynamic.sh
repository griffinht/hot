#!/bin/bash

# path to token
token=$(cat "$1")
zone_name="$2"

request() {
  curl -sS -X GET "https://api.cloudflare.com/client/v4/$1" -H "Authorization: Bearer $token" -H "Content-Type:application/json"
}

#zone_id=$(request "zones" \
zone_id=$(cat response \
  | jq '.result[]| select(.name == "'"$zone_name"'").id')

echo "$zone_id"