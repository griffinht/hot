#!/usr/bin/env sh

#requires wireguard-tools qrencode

server="$1"
#guix deploy deploy.scm -x -- wg show wg0 public-key"
server='S1pSAKnzImf/la1ZoezJYs93pIazKuKb+5Tu4jlyp1w='
if [ -z "$server" ]; then
    echo please provide server pubkey
    exit 1
fi

address="$2"
if [ -z "$address" ]; then
    echo please provide client address eg 10.0.0.3
    exit 1
fi

private="$(wg genkey)"

#cat << EOF
qrencode -t ansiutf8 << EOF
[Interface]
Address = $address
PrivateKey = $private
DNS = 8.8.8.8
#ListenPort

[Peer]
PublicKey = $server
AllowedIPs = 192.168.0.0/16
Endpoint = hot.griffinht.com:51820
EOF

echo "$private" | wg pubkey | xargs -0 printf "New client's pubkey: %sAdd this to the host's peer configurations with address $address\n"
