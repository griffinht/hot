#!/bin/bash
set -e

echo "$CERTBOT_CLOUDFLARE" > ./certbot_cloudflare
echo her it comes
cat ./certbot_cloudflare
echo that was it
exit 0
while true; do
  ./certbot.sh;
  sleep 1d
done;
