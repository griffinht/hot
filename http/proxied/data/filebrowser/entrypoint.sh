#!/bin/sh

if [ ! -f "/data/filebrowser.db" ]; then
  /filebrowser -d /data/filebrowser.db config init
fi

/filebrowser -d /data/filebrowser.db config set \
    --baseurl "/filebrowser" \
    --address "" \
    --root "public" \
    --auth.method "noauth"

/filebrowser -d /data/filebrowser.db users update 1 \
    --username "user" \
    --perm.admin=false \
    --perm.execute=false \
    --perm.share=false

/filebrowser -d /data/filebrowser.db
