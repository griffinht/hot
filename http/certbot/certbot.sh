#!/bin/bash

# https://community.letsencrypt.org/t/prevent-0001-xxxx-certificate-suffixes/66802/4
#  --test-cert \
certbot certonly \
  --cert-name griffinht.com \
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

#  --test-cert \
#  --break-my-certs \
certbot certonly \
  --cert-name griffinht.com \
  --expand \
  -d griffin.ht \
  \
  --noninteractive \
  --register-unsafely-without-email \
  --agree-tos \
  \
  --dns-route53