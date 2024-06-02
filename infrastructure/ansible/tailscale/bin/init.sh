#!/bin/sh

# https://tailscale.com/kb/1147/cloud-gce#step-4-add-gce-dns-for-your-tailnet
ssh.sh tailscale up --advertise-routes="${IPV4?}" --accept-dns=true
echo go to tailscale https://login.tailscale.com/admin/machines and accept the subnet routes???
echo 'then sudo tailscale up --accept-routes on client machines like ur dev machine'
