#!/usr/bin/env sh

guix shell nginx -- nginx -g 'daemon off; error_log /dev/stdout info;' -c "$PWD/nginx.conf" -p "$PWD" "$@"
