#!/bin/bash
set -e

echo "$CERTBOT_CLOUDFLARE" > ./certbot_cloudflare

printf "[default]\naws_access_key_id=%s\naws_secret_access_key=%s" "$CERTBOT_AWS_ACCESS_KEY_ID" "$CERTBOT_AWS_SECRET_ACCESS_KEY"> ./certbot_aws
export AWS_CONFIG_FILE=./certbot_aws

while true; do
  ./certbot.sh;
  sleep 1d
done;
