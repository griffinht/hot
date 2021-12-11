#!/bin/bash

CLOUDFLARE_API_TOKEN="$1"
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "Specify a CLOUDFLARE_API_TOKEN for certbot"
  echo "Go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token"
  echo "Token name: hot_certbot"
  echo "Permissions: Zone, DNS, Read/Edit (and edit for cloudflare-dynamic.sh)"
  echo "Continue to summary > Create Token > (pass given token as first argument)"
  read -rp "CLOUDFLARE_API_TOKEN: " CLOUDFLARE_API_TOKEN
fi
echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" > bin/dynamic-ip_cloudflare