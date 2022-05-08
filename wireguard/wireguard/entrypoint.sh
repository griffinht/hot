#!/bin/bash

# check if wireguard kernel modules are loaded
if ! grep wireguard < /proc/modules; then
    echo wireguard kernel modules are not loaded, exiting 
    exit 1
fi

echo wireguard kernel modules are loaded

# check for existing interface wg0
if wg show wg0; then
    echo interface wg0 already exists, exiting
    exit 1
fi
echo interface wg0 not detected, adding

# add interface wg0
if ! ip link add dev wg0 type wireguard; then
    echo "ip link add dev wg0 type wireguard exited with $?, did you forget --cap-add=NET_ADMIN"
fi

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
