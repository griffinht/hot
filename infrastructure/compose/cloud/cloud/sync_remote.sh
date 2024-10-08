#!/bin/sh

path='../mnt/cloud_config/_data'
rm -r "${path:?}/*"
cp -r nginx/* "$path"
./compose.sh exec nginx nginx -p / -e /dev/stderr -c /config/nginx.conf -s reload
