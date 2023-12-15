#!/usr/bin/env sh

set -e

inotifywait -m -e modify conf |
    while read -r direct event file; do
        docker compose exec --no-TTY nginx \
            nginx -s reload
        echo reloaded
    done
