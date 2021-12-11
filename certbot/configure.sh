#!/bin/bash

CLOUDFLARE_API_TOKEN="$1"
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then printf "Specify a CLOUDFLARE_API_TOKEN - go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token\nToken name: hot_certbot\nPermissions: Zone, DNS, Read/Edit (and edit for cloudflare-dynamic.sh)\nContinue to summary > Create Token > (pass given token as first argument)\n"; exit 1; fi
echo "dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" > bin/dynamic-ip_cloudflare