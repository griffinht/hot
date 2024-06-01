#!/bin/sh

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@"${COMPUTE_IP?}"
