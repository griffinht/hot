#!/bin/sh

set -x

guix shell cloudflare-cli -- sh -c ". ./.env && cloudflare-cli Bearer \$CLOUDFLARE_API_TOKEN griffinht.com A @"
