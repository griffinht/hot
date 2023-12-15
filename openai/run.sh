#!/usr/bin/env sh

docker compose run --rm -it -p 8080:80 nginx > log
