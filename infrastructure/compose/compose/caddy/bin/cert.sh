#!/bin/sh

docker compose run --rm -it certbot \
    --dns-cloudflare \
    --dns-cloudflare-credentials '/secrets/cloudflare.ini' \
    -d 'cool.griffinht.com' \
    -d '*.cool.griffinht.com' \
    certonly
