#!/bin/sh

set -xe

ssh root@cloudtest.lan.hot.griffinht.com docker image load < "$(./scripts/pack2.sh "$1")"
