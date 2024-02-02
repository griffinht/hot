#!/bin/sh

mkdir -p mnt.bin

# todo use ssh.sh for -i id_ed25519 and other flags
sshfs -o default_permissions,uid="$(id -u)",gid="$(id -g)" \
    -i id_ed25519.bin \
    root@localhost:/ mnt.bin
