#!/usr/bin/env sh

#./xandikos.sh -d $PWD/bruh --current-user-principal /griffin --defaults -l 0.0.0.0
guix shell xandikos -- xandikos "$@"
