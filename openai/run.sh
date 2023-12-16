#!/usr/bin/env sh

logfile=log
echo "logging output to $logfile"

docker compose run --rm -it -p 8080:80 nginx > "$logfile"
