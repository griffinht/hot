#!/bin/sh

set -xe

#    -S /etc/profile=etc/profile \
#    -S /bruh2= \

guix pack \
    --no-substitutes \
    --format=docker \
    --compression=none \
    --image-tag=mygit \
    --symlink=/bin=bin \
    git bash | xargs cat | podman load
#guix pack --format=docker --compression=none --image-tag=myssh openssh-sans-x git bash coreutils which
