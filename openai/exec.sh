#!/usr/bin/env sh

docker compose exec -it \
    nginx nginx "$@"
