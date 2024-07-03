#!/bin/sh

#https://guix.gnu.org/cookbook/en/html_node/Network-bridge-for-QEMU.html
nmcli con add type bridge
nmcli con add type bridge-slave master nm-bridge
