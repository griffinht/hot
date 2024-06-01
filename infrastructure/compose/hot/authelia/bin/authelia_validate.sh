#!/bin/sh

docker compose run --rm -it authelia authelia config validate --config /authelia_config/configuration.yml
