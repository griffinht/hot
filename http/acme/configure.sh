#!/bin/bash

CLOUDFLARE_API_TOKEN="$1"
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo
  echo "Specify a CLOUDFLARE_API_TOKEN for certbot"
  echo "https://developers.cloudflare.com/api/tokens/create"
  echo "Go to Cloudflare dashboard > Person Icon (top right) > My Profile > API Tokens > Create Token > Custom Custom Token"
  echo "Token name: hot_certbot"
  echo "Permissions: Zone, DNS, Edit + Zone, Zone, Read"
  echo "Continue to summary > Create Token > (enter token below)"
  read -srp "CLOUDFLARE_API_TOKEN: " CLOUDFLARE_API_TOKEN
  echo
fi
echo "CERTBOT_CLOUDFLARE=dns_cloudflare_api_token = $CLOUDFLARE_API_TOKEN" >> .env

AWS_ACCESS_KEY_ID="$2"
AWS_SECRET_ACCESS_KEY="$3"
if [ -z "$2" ] || [ -z "$3" ]; then
  echo
  echo "Specify a AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
  echo "https://certbot-dns-route53.readthedocs.io/en/stable/"
  echo "https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys"
  echo "https://github.com/acmesh-official/acme.sh/wiki/How-to-use-Amazon-Route53-API"
  echo "Set up policy:"
  echo "IAM > Policies > Create Policy"
  echo "Copy AWS policy file from the bottom (restrictive AWS policy) of https://github.com/acmesh-official/acme.sh/wiki/How-to-use-Amazon-Route53-API"
  echo "Make sure to replace hosted zone id with your zone"
  echo "Next: tags > Next: Review"
  echo "Name*: hot_certbot"
  echo "Create Policy"
  echo "IAM > Users > Create User"
  echo "User name*: hot_certbot"
  echo "Select AWS credential type*: Access key - Programmatic access"
  echo "Next: Permissions > Attach existing policies directly"
  echo "Select hot_certbot policy (use the search box)"
  echo "Next: tags > Next : Review > Create User"
  echo "Enter access key ID and Secret access key below"
  read -srp "Access key ID: " AWS_ACCESS_KEY_ID
  echo
  read -srp "Secret access key: " AWS_SECRET_ACCESS_KEY
  echo
fi

echo "CERTBOT_AWS_ACCESS_KEY_ID = $AWS_ACCESS_KEY_ID" >> .env
echo "CERTBOT_AWS_SECRET_ACCESS_KEY = $AWS_SECRET_ACCESS_KEY" >> .env