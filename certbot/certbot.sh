#!/bin/bash

certbot certonly \
  --register-unsafely-without-email \
  --agree-tos \
  --noninteractive \
  -d hot.stzups.net \
  --dns-cloudflare \
  --dns-cloudflare-credentials "$CLOUDFLARE_CREDENTIALS_FILE"