#!/bin/bash

CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4/
ZONE_ID_FILE=zone-id
DNS_RECORD_ID_FILE=dns-record-id

cloudflare_api() {
    CLOUDFLARE_API_TOKEN="$1"
    METHOD="$2"
    CLOUDFLARE_API_PATH="$3"
    curl -sS -X "$METHOD" "$CLOUDFLARE_API_URL$CLOUDFLARE_API_PATH" \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type:application/json"
}

cloudflare_api_post() {
  CLOUDFLARE_API_TOKEN="$1"
  CLOUDFLARE_API_PATH="$2"
  DATA=$3
  curl -sS -X POST "$CLOUDFLARE_API_URL$CLOUDFLARE_API_PATH" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json" \
    --data "$DATA"
}

function manual-auth-hook()
{
  CLOUDFLARE_API_TOKEN="$1"
#  DOMAIN="$CERTBOT_DOMAIN"
  DOMAIN="$2"
#  VALIDATION="$CERTBOT_VALIDATION"
  VALIDATION="$3"
#
  cloudflare_api "$CLOUDFLARE_API_TOKEN" GET zones > test1

  if [ "$(jq -r '.success' < test1)" != "true" ]; then
    echo "Error getting zone id for domain $DOMAIN via GET to zones"
    jq '.errors' < test1
    exit 1
  fi
  ZONE_ID=$(jq -r '.result[]| select(.name == "'"$DOMAIN"'").id' < test1)
  if [ -z "$ZONE_ID" ]; then
    echo "Zone id not found for domain $DOMAIN via GET to zones"
    exit 1
  fi;
  echo "Got zone id $ZONE_ID for domain $DOMAIN via GET to zones"
  echo "$ZONE_ID" > "$ZONE_ID_FILE"
#
  cloudflare_api_post "$CLOUDFLARE_API_TOKEN" "zones/$ZONE_ID/dns_records" '{"type":"TXT","name":"_acme-challenge","content":"'"$VALIDATION"'","ttl":"1"}' > test2
  if [ "$(jq -r '.success' < test2)" != "true" ]; then
    echo "Error creating DNS record with type TXT with _acme-challenge = $VALIDATION via POST to zones/$ZONE_ID/dns_records"
    jq '.errors' < test2
    exit 1
  fi
  DNS_RECORD_ID=$(jq -r '.result.id' < test2)
  echo "Created DNS record with id $DNS_RECORD_ID with type TXT with _acme-challenge = $VALIDATION via POST to zones/$ZONE_ID/dns_records"
  echo "$DNS_RECORD_ID" > "$DNS_RECORD_ID_FILE"
}

function manual-cleanup-hook() {
  CLOUDFLARE_API_TOKEN="$1"
  ZONE_ID=$(cat "$ZONE_ID_FILE")
  DNS_RECORD_ID=$(cat "$DNS_RECORD_ID_FILE")
  rm "$DNS_RECORD_ID_FILE"
  rm "$ZONE_ID_FILE"

  echo "$ZONE_ID and $DNS_RECORD_ID"
#
  cloudflare_api "$CLOUDFLARE_API_TOKEN" DELETE "zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" > test4
  if [ "$(jq -r '.success' < test4)" != "true" ]; then
    echo "Error deleting DNS record via DELETE to zones/$ZONE_ID/dns_records/$DNS_RECORD_ID"
    jq '.errors' < test4
    exit 1
  fi
  echo "Deleted DNS record via DELETE to zones/$ZONE_ID/dns_records/$DNS_RECORD_ID"
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