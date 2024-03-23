#!/bin/sh

set -xe

podman image load < "$(./scripts/pack2.sh "$1")"
