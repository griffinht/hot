#!/bin/sh

guix='./guix.sh'
guix='docker compose exec -T guix guix'
guix shell guix -- sh -c "
set -ex

$guix archive --authorize < \"\$GUIX_ENVIRONMENT/share/guix/ci.guix.gnu.org.pub\"
$guix archive --authorize < \"\$GUIX_ENVIRONMENT/share/guix/bordeaux.guix.gnu.org.pub\"
"
