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
    echo please provide client endpooint eg example.com > /dev/stderr
    exit 1
fi

allowed="$4"
if [ -z "$allowed" ]; then
    echo please provide allowedip eg 192.168.0.0/24 > /dev/stderr
    exit 1
fi

private_key_file="$5"
if [ -z "$private_key_file" ]; then
    echo please provide private key file or - for stdin private key > /dev/stderr
    exit 1
fi

if [ "$private_key_file" == '-' ]; then
    read private
    private="PrivateKey = $private"
else
    private="PostUp = wg set %i private-key $private_key_file"
fi



cat << EOF
[Interface]
Address = $address
$private

[Peer]
PublicKey = $public
AllowedIPs = $allowed
Endpoint = $endpoint
EOF

