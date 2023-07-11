#!/usr/bin/env sh

guix shell syncthing -- \
    syncthing serve \
    --no-browser \
    --home=syncthing \
    --no-upgrade
