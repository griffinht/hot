#!/bin/sh

set -xe

    #-I nixpkgs=channel:nixos-23.11 \
nix-build '<nixpkgs/nixos>' \
    -A vm \
    -I nixos-config=./configuration.nix
