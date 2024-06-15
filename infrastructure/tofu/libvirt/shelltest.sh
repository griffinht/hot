#!/bin/sh

shell.sh "${1?specify local.env or shell.env}" -- tunnel3.sh shell.sh tunnel.env
