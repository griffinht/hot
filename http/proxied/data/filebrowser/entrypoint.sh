#!/bin/sh

/filebrowser -d /data/filebrowser.db config init

/filebrowser -d /data/filebrowser.db config set \
    --baseurl "/filebrowser" \
    --address "" \
    --port "80" \
    --root "public" \
    --auth.method "noauth"

/filebrowser -d /data/filebrowser.db users add user password \
    --perm.admin=false \
    --perm.execute=false \
    --perm.share=false \
    --lockPassword=true

/filebrowser -d /data/filebrowser.db
