#!/bin/bash
# get these values using cloudflare.sh
ZONE_ID="$ZONE_ID"
DNS_IDS="$DNS_IDS"

OLD_CONTENT=
while true; do
  CONTENT=$(curl -s icanhazip.com)
  #todo check error code
  if [ "$OLD_CONTENT" != "$CONTENT" ]; then
    echo "updating $OLD_CONTENT to $CONTENT"
    #todo reload nginx
    #todo mikrotik
    if ./cloudflare.sh "$(cat "/run/secrets/dynamic-ip_cloudflare")" "$(cat /ids)" "$CONTENT"; then OLD_CONTENT="$CONTENT"; fi
  fi;
#todo interval
  sleep 1m
done;
