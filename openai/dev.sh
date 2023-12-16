#!/usr/bin/env sh

log_file=log

reload() {
        KEY_FILE='/secrets/keyfile' make build \
            && docker compose exec --no-TTY nginx \
                nginx -s reload
}

reload

echo "logging all output and error messages to $log_file"
inotifywait -m -e modify nginx |
    while read -r direct event file; do
        reload 2>> "$log_file"
    done
