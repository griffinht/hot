#!/bin/sh

# todo no subs
guix pack \
    --format=docker \
    --image-tag="$1" \
    --manifest="$1/manifest.scm"
