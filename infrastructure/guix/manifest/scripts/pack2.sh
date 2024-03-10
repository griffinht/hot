#!/bin/sh

# todo no subs
guix pack \
    --format=docker \
    --no-substitutes \
    "$1"
