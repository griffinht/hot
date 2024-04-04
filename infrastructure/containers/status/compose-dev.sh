#!/bin/sh

docker compose \
    --env-file=develop.env
    "$@"
