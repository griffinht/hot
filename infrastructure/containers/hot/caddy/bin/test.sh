#!/bin/bash

set -eu
set -o pipefail

host="${1?please specify a host}"

bruh() {
    get_code() {
        curl -o /dev/null \
            -s \
            -w "%{http_code}" \
            "$1"
    }
    if [ "$(get_code "$1")" -eq "$2" ]; then
        return 0
    fi

    echo "$1" != "$2"
    curl -I "$1"
    curl "$1"
    return 1
}

bruh "$host" 404
#bruh "miniflux.$host" 200
