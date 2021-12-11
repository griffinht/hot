#!/bin/bash

OLD_CONTENT=
while true; do
  CONTENT=$(curl icanhazip.com)
  if [ "$OLD_CONTENT" -ne "$CONTENT" ]; then
    ./cloudflare-dynamic.sh "$(cat "/run/secrets/cloudflare-dynamic_cloudflare")" zone_id dns_ids new_content;
    OLD_CONTENT="$NEW_CONTENT"
  fi;
  sleep 1d
done;
