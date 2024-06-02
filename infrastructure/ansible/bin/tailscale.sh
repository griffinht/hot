#!/bin/sh

ssh "root@${1?}" tailscale up
