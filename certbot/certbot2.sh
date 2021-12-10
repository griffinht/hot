#!/bin/bash

function certbot-certonly()
{
  DOMAIN="$1"

  certbot certonly \
    --test-cert \
    -d "$DOMAIN" \
    --preferred-challenges dns \
    \
    --manual \
    --manual-auth-hook "./certbot2.sh manual-auth-hook" \
    --manual-cleanup-hook "./certbot2.sh manual-cleanup-hook" \
    \
    --noninteractive \
    --register-unsafely-without-email \
    --agree-tos \
    \
    --config-dir test/config \
    --work-dir test/work \
    --logs-dir test/logs

}

function manual-auth-hook()
{
  echo "manual-auth-hook running"
  echo "$CERTBOT_VALIDATION" > validation
  sleep 1000000000
  exit 1
  curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
       -H "Authorization: Bearer 69kTGmktcokw0ackJP6X6L9DTke0433C-j6REIRg" \
       -H "Content-Type:application/json"
# txt record _acme-challenge
  exit 1
}

function manual-cleanup-hook() {
  echo "manual-cleanup-hook running"
  echo "cleaning up"
  exit 1
}

"$@"