#!/bin/sh

set -xe

bruh() {
    echo todo quit sync
    read -r bruh
    if [ -n "${SSH_HOST+x}" ]; then
        scp -r caddy_config/* "${SSH_HOST?}:/var/lib/docker/volumes/caddy_caddy_config/_data"
    fi
}
docker compose cp caddy_config/Caddyfile caddy:/etc/caddy/Caddyfile
docker compose exec caddy caddy reload --config /etc/caddy/Caddyfile
