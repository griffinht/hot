#!/bin/sh

DOCKER_HOST=ssh://root@cloudtest.lan.hot.griffinht.com docker compose -f compose.yml "$@"
