#!/bin/bash

certbot certonly \
  -d griffinht.com \
  -d scribbleshare.com \
  \
  --noninteractive \
  --register-unsafely-without-email \
  --agree-tos \
  \
  --dns-cloudflare \
  --dns-cloudflare-credentials "/run/secrets/certbot_cloudflare"
