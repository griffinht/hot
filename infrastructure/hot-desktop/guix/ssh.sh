#!/usr/bin/env sh

. ./env.env

ssh -p "$SSH_PORT" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "root@$HOST"
