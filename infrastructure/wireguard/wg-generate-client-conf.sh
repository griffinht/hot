#!/usr/bin/env sh

public="$1"
if [ -z "$public" ]; then
    echo please provide server pubkey > /dev/stderr
    exit 1
fi

address="$2"
if [ -z "$address" ]; then
    echo please provide client address eg 10.0.0.3 > /dev/stderr
    exit 1
fi

endpoint="$3"
if [ -z "$endpoint" ]; then
    echo please provide client address eg example.com > /dev/stderr
    exit 1
fi

allowed="$4"
if [ -z "$allowed" ]; then
    echo please provide client address eg example.com > /dev/stderr
    exit 1
fi

private="$(read || (echo error read > /dev/stderr; exit 1))"

cat << EOF
[Interface]
Address = $address
#PrivateKey = $private
PostUp = wg set %i private-key /etc/wireguard/private.key

[Peer]
PublicKey = $public
AllowedIPs = $allowed
Endpoint = $endpoint
EOF

