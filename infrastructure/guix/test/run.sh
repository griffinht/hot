#!/bin/sh

guix shell \
    --container \
    docker-cli podman \
    -- ./test.sh
