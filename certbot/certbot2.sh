#!/bin/bash

CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4/



cloudflare_api_get() {
  CLOUDFLARE_API_TOKEN="$1"
  CLOUDFLARE_API_PATH="$2"
  cloudflare
  curl -sS -X GET "$CLOUDFLARE_API_URL$CLOUDFLARE_API_PATH" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json"
}

cloudflare_api_post() {
  CLOUDFLARE_API_TOKEN="$1"
  CLOUDFLARE_API_PATH="$2"
  DATA=$3
  cloudflare "$CLOUDFLARE_API_TOKEN"
  curl -sS -X POST "$CLOUDFLARE_API_URL$CLOUDFLARE_API_PATH" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json" \
    --data "$DATA"
}

function manual-auth-hook()
{
  CLOUDFLARE_API_TOKEN="$1"
#
#  cloudflare_api_get "$CLOUDFLARE_API_TOKEN" zones > test1

  ZONE_ID=$(jq -r '.result[]| select(.name == "'"$CERTBOT_DOMAIN"'").id' < test1)
  if [ -z "$ZONE_ID" ]; then
    echo "Zone id for domain $CERTBOT_DOMAIN not found via GET to zones"
    exit 1
  fi;
  echo "Got zone id $ZONE_ID for domain $CERTBOT_DOMAIN via GET to zones"
#
#  cloudflare_api_post "$CLOUDFLARE_API_TOKEN" "zones/$ZONE_ID/dns_records" '{"type":"TXT","name":"_acme-challenge","content":"'"$CERTBOT_VALIDATION"'","ttl":"1"}' > test2
  if [ "$(jq -r '.success' < test2)" != "true" ]; then
    echo "Error creating DNS record with type TXT with _acme-challenge = $CERTBOT_VALIDATION via POST to zones/$ZONE_ID/dns_records"
    jq '.errors' < test2
    exit 1
  fi
  DNS_RECORD_ID=$(jq -r '.result.id' < test2)
  echo "Created DNS record with id $DNS_RECORD_ID with type TXT with _acme-challenge = $CERTBOT_VALIDATION via POST to zones/$ZONE_ID/dns_records"

  exit 1
}

function manual-cleanup-hook() {
  CLOUDFLARE_API_TOKEN="$1"
  echo "manual-cleanup-hook running"
  echo "cleaning up"
  exit 1
}

function certbot-certonly()
{
  DOMAIN="$1"
  # token needs the following for each zone (domain) it can manipulate
  # Zone.Zone:Read
  # Zone.DNS:Edit
  CLOUDFLARE_API_TOKEN="$2"

  if [ -z "$DOMAIN" ]; then
    echo "DOMAIN not set"
    exit 1
  fi;
  if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "CLOUDFLARE_API_TOKEN not set"
    echo ""
    exit 1
  fi;

  certbot certonly \
    --test-cert \
    -d "$DOMAIN" \
    --preferred-challenges dns \
    \
    --manual \
    --manual-auth-hook "./certbot2.sh manual-auth-hook $CLOUDFLARE_API_TOKEN" \
    --manual-cleanup-hook "./certbot2.sh manual-cleanup-hook $CLOUDFLARE_API_TOKEN" \
    \
    --noninteractive \
    --register-unsafely-without-email \
    --agree-tos \
    \
    --config-dir test/config \
    --work-dir test/work \
    --logs-dir test/logs

}

"$@"