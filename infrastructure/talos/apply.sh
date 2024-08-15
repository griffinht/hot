#!/bin/sh

# i want to break the cluster! destroy it! cause downtime unexpectedly!

set -e

# https://www.talos.dev/v1.7/talos-guides/configuration/editing-machine-configuration/

jsonnet controlplane.json \
    | talosctl apply-config \
    --file /dev/stdin \
    --dry-run

try() {
    jsonnet controlplane.json \
        | talosctl apply-config \
        --file /dev/stdin \
        --mode=try
}

apply() {
    jsonnet controlplane.json \
        | talosctl apply-config \
        --file /dev/stdin \
        --mode=auto
        #--mode=no-reboot
}

apply
exit 0
echo continue with "$@" ?
read -r test

"$@"
