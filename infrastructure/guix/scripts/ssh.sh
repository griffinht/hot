#!/bin/sh

. ./dev.env && ssh -p "$SSH_PORT" "$USER@localhost" "$@"
