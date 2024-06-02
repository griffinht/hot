#!/bin/sh

XDG_CONFIG_HOME=$PWD \
    LAMINAR_HOST=localhost:9997 \
    LAMINAR_REASON='./cron.sh dev test script' \
    guix shell mcron laminar -- \
    mcron --log
