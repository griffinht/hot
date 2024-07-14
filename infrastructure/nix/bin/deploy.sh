#!/bin/sh

cat configuration.nix | ssh.sh sh -c 'cat > /etc/nixos/configuration.nix && nixos-rebuild switch'
