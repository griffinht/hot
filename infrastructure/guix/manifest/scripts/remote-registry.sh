#!/bin/sh

set -xe

name="$1"
prefix="griffinht/"

# todo sign images??
#podman load < "$(./scripts/pack2.sh "$name")"
#podman push --tls-verify=false "$name" "docker://cloudtest.lan.hot.griffinht.com:5000/repo/$name"
repo="docker://cloudtest.lan.hot.griffinht.com:5000"
#skopeo "$flags" delete "$repo/$prefix$name"
flags='--tls-verify=false'
skopeo "$flags" copy "docker-archive:$(./scripts/pack2.sh "$name")" "$repo/$prefix$name"
