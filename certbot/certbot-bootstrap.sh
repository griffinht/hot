#!/bin/bash

CLOUDFLARE_API_TOKEN="ElJVsueh0PWy-asGal1mOSAg08uoqcqMdXoYFEpe"
CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4/
CERTBOT_DOMAIN=griffinht.com

cloudflare_api_get() {
 curl -sS -X GET "$CLOUDFLARE_API_URL""$1" \
   -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
   -H "Content-Type:application/json"
}

cloudflare_api_post() {
 curl -sS -X POST "$CLOUDFLARE_API_URL""$1" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type:application/json" \
  --data "$2"
}

cloudflare_api_get zones > test1

ZONE_ID=$(jq -r '.result[]| select(.name == "'"$CERTBOT_DOMAIN"'").id' < test1)
if [ -z "$ZONE_ID" ]; then
  echo "Zone id for domain $CERTBOT_DOMAIN not found"
  exit 1
fi;
echo "Found zone id $ZONE_ID for domain $CERTBOT_DOMAIN"
exit 1
curl -X POST "$CLOUDFLARE_API_URL""zones/$ZONE_ID/dns_records" \
     -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
     -H "Content-Type:application/json" > test1




#./certbot2.sh certbot-certonly "$CLOUDFLARE_API_TOKEN"