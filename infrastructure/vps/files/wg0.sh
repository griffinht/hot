#!/usr/bin/env sh

if [ -f /etc/wireguard/wg0.conf ]; then
    exit 0
fi

PRIVATE="$(wg genkey)"
PUBLIC="$1"

# print server public key
"$(echo PRIVATE)" | wg pubkey > pubkey

cat > /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = $PRIVATE
Address = 10.0.0.1
# todo necessary?
ListenPort = 51822

[Peer]
PublicKey = $PUBLIC
AllowedIPs = 10.0.0.2
EOF

chmod 022 /etc/wireguard/wg0.conf
