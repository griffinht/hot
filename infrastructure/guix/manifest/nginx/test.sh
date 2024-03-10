#!/bin/sh

podman run --rm -it \
    -v ./nginx.conf:/nginx.conf:ro \
    -v ./passwd:/etc/passwd:ro \
    -v ./group:/etc/group:ro \
    --user root \
    localhost/nginx nginx \
        -p / \
        -e '/dev/stderr' \
        -c '/nginx.conf'
