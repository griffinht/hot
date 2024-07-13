#!/bin/sh

set -e

docker compose cp config/config.yml samba:/config
# samba takes annoyingly long to restart otherwise
docker compose stop -t 0 samba
docker compose restart samba
docker compose logs --tail=50 samba
