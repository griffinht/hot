#!/bin/sh

webhook -hooks hooks.yml -verbose

ls /etc/caddy/Caddyfile | entr caddy adapt --config /etc/caddy/Caddyfile > /output/bruh
