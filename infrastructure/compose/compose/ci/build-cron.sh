#!/bin/sh

set -xe

guix pack \
    --no-substitutes \
    --format=docker \
    --compression=none \
    --image-tag=mylaminarcron \
    --symlink=/bin=bin \
    laminar bash mcron | xargs cat | podman load
