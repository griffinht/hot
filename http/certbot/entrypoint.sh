#!/bin/bash
set -e

echo "$CERTBOT_CLOUDFLARE" > ./certbot_cloudflare

while true; do
  ./certbot.sh;
  sleep 1d
done;
