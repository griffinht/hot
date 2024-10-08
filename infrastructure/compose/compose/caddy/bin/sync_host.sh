#!/bin/sh

set -xe

if [ -n "${SSH_HOST+x}" ]; then
    scp -r caddy_host_config/* "${SSH_HOST?}:/var/lib/docker/volumes/caddy_caddy_host_config/_data"
fi
docker compose exec caddy_host caddy reload --config /etc/caddy/Caddyfile
