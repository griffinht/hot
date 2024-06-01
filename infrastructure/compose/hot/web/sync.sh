#!/bin/sh

set -xe

scp -r caddy_config/* "${SSH_HOST?}:/var/lib/docker/volumes/web_caddy_config/_data"
docker compose exec caddy caddy reload --config /etc/caddy/Caddyfile
