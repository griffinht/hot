#!/bin/bash

# todo remove --test-cert on 12/31
# todo add aws griffin.ht
certbot certonly \
  --test-cert \
  -d griffinht.com \
  -d stzups.net \
  -d scribbleshare.com \
  -d realgmoney.com \
  -d lemonpickles.net \
  \
  --noninteractive \
  --register-unsafely-without-email \
  --agree-tos \
  \
  --dns-cloudflare \
  --dns-cloudflare-credentials "./certbot_cloudflare"
