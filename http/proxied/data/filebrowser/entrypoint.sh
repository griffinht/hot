#!/bin/sh

if [ ! -f "/data/filebrowser.db" ]; then
  /filebrowser -d /data/filebrowser.db config init
fi

/filebrowser -d /data/filebrowser.db config set \
    --baseurl "/filebrowser" \
    --address "" \
    --root "public"

/filebrowser -d /data/filebrowser.db
