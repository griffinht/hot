#!/bin/bash

DOMAIN="$1"

certbot certonly \
  -d "$DOMAIN" \
  \
  --noninteractive \
  --register-unsafely-without-email \
  --agree-tos \
  \
  --dns-cloudflare \
  --dns-cloudflare-credentials "/run/secrets/certbot_cloudflare"
