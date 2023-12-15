#!/usr/bin/env sh

podman run --rm -it \
    --name nginxtest \
    -v ./conf:/etc/nginx/ \
    nginx:alpine
