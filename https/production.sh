#!/usr/bin/env sh

source production.env
docker compose -f docker-compose.yml $@
