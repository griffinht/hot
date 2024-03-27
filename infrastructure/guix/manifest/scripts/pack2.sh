#!/bin/sh

# todo no subs
guix pack \
    --format=docker \
    "$1"
