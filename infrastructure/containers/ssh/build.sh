#!/bin/sh

guix pack \
    --no-substitutes \
    --format=docker \
    --compression=none \
    -S /etc/profile=etc/profile \
    -S /bruh2= \
    --image-tag=myssh \
    openssh-sans-x git bash coreutils which | xargs cat | podman load
#guix pack --format=docker --compression=none --image-tag=myssh openssh-sans-x git bash coreutils which
