#!/bin/sh

LAMINAR_HOST=localhost:9997 \
    LAMINAR_REASON='./laminar.sh dev test script' \
    guix shell laminar -- laminarc "$@"
