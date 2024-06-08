#!/bin/sh

set -xe

action="$1"
shift

guix "$action" --load-path=channel "$@"
