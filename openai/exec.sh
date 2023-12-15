#!/usr/bin/env sh

podman exec -it \
    nginxtest nginx "$@"
