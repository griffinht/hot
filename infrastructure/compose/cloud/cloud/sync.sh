#!/bin/sh

rm -r ~/.local/share/containers/storage/volumes/cloud_config/_data/*
cp -r nginx/* ~/.local/share/containers/storage/volumes/cloud_config/_data
docker compose exec nginx nginx -p / -e /dev/stderr -c /config/nginx.conf -s reload
