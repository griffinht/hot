#!/bin/sh

docker compose up -d \
    --remove-orphans \
    --abort-on-container-failures
