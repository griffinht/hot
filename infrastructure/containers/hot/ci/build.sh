#!/bin/sh

set -xe

# laminar 1.3 is broken :(
# i should really just use docker...
# https://issues.guix.gnu.org/68388
guix pack \
    --no-substitutes \
    --format=docker \
    --compression=none \
    --image-tag=mylaminar \
    --symlink=/bin=bin \
    --with-version=laminar=1.2 \
    laminar bash | xargs cat | podman load
