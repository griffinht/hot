#!/bin/sh

set -xe

echo 'ip address? get it from'
echo 'hcloud server list | grep control'
read -r address

talosctl --talosconfig talosconfig config endpoint "$address"
talosctl --talosconfig talosconfig config node "$address"

talosctl --talosconfig talosconfig bootstrap

talosctl --talosconfig talosconfig kubeconfig
