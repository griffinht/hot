#!/bin/sh

set -xe

guix pack \
    --no-substitutes \
    --format=docker \
    --compression=none \
    --image-tag=mycron \
    --symlink=/bin=bin \
    laminar bash cron | xargs cat | podman load
