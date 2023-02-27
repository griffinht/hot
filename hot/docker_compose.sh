#!/usr/bin/env sh

EXIT=0

for dir in proxied/*; do
    (
    cd $dir
    
    if [ -n "$PRODUCTION" ]; then
        if [ -f production.env ]; then
            source ./production.env
        else
            export COMPOSE_FILE=docker-compose.yml
        fi
    fi

    if ! docker compose $@; then
        echo "docker compose $@ exited with code $?"
        echo ======================================
        exit 1
    fi
    ) || EXIT=1
done

if [ "$EXIT" -ne 0 ]; then echo ===================== non zero exit code; fi

exit "$EXIT"
