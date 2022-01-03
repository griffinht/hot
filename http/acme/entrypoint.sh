#!/bin/bash

export CF_Token="$CERTBOT_CLOUDFLARE"

export AWS_ACCESS_KEY_ID="$CERTBOT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CERTBOT_AWS_SECRET_ACCESS_KEY"

while true; do
  ./acme.sh;
  sleep 1d
done;
