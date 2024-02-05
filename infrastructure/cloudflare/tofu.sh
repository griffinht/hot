#!/bin/sh

set -x

. ./.env && tofu "$@"
