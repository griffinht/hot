#!/bin/sh

# todo no subs
guix pack \
    --format=docker \
    --no-substitutes \
    --manifest="$1/manifest.scm"
