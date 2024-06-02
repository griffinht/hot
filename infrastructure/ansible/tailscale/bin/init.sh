#!/bin/sh

# https://tailscale.com/kb/1147/cloud-gce#step-4-add-gce-dns-for-your-tailnet
ssh.sh tailscale up --advertise-routes="${IPV4?}" --accept-dns=true
