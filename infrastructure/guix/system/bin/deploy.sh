#!/bin/bash

deploy() {
    guix.sh deploy "$1/deploy.scm"
}
export -f deploy

build() {
    guix.sh system build "$1/system.scm"
}
export -f build

check() {
    echo "(load \"$1/system.scm\")" | guix.sh repl
}
export -f check

parallel \
    --line-buffer \
    --tag \
    -j 6 \
    "${1?usage: $0 build|deploy}" ::: \
    nerd-vps \
    hypervisor \
    guix \
    cloudtest \
    hot \
    griffinht \
    hot-data
