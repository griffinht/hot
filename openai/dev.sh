#!/usr/bin/env sh

inotifywait -m -e modify nginx |
    while read -r direct event file; do
        docker compose exec --no-TTY nginx \
            nginx -s reload 2>> log
    done
