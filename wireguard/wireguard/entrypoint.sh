#!/bin/sh

PRIVATE_KEY_FILE="${PRIVATE_KEY_FILE:-/wireguard/privatekey"
PEERS_DIRECTORY="${PEERS_DIRECTORY:-/wireguard/peers"
SUBNET="$SUBNET:-10.0.0.0/24"

# check if wireguard kernel modules are loaded
if ! grep wireguard < /proc/modules; then
    echo wireguard kernel modules are not loaded, exiting 
    exit 1
fi

echo wireguard kernel modules are loaded

# check for existing interface wg0
if wg show wg0 2> /dev/null; then
    echo interface wg0 already exists, exiting
    exit 1
fi
echo interface wg0 not detected, adding

# add interface wg0
if ! ip link add dev wg0 type wireguard; then
    echo "ip link add dev wg0 type wireguard exited with $?, did you forget --cap-add=NET_ADMIN"
fi

# generates private key if it does not exist, then writes to /dev/stderr
get_private_key() {
    if ! [ -e "$PRIVATE_KEY_FILE" ]; then
        echo generating new private key in "$PRIVATE_KEY_FILE" >&2
        wg genkey > "$PRIVATE_KEY_FILE"
    fi
    ls -l "$PRIVATE_KEY_FILE" >&2
    cat "$PRIVATE_KEY_FILE"
}

configure() {
    echo hello
    sleep 111100
}

# make sure to clean up interface if configuration fails
if ! configure; then
    echo configuring interface wg0 failed, deleting and aborting
    ip link delete wg0
    exit 1
fi
