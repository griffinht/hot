#!/bin/bash

mkdir -p ../bin/
echo "Cerbot setup"
read -p "Cloudflare api token (https://dash.cloudflare.com/profile/api-tokens) (for dns): " cloudflare_api_token
echo "dns_cloudflare_api_token = $cloudflare_api_token" > ../bin/certbot_cloudflare
echo "ExpressVPN setup"
read -p ".conf or .ovpn file path: " vpn_file
read -p "username: " vpn_username
read -p "password: " vpn_password
../openvpn-client/vpn-setup.sh "$vpn_file" "$vpn_username" "$vpn_password"