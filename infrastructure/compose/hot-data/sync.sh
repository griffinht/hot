#!/bin/sh

scp -r config/* "${SSH_HOST?}:/var/lib/docker/volumes/hot-data_config/_data"
docker compose restart samba
docker compose logs --tail=50 samba
