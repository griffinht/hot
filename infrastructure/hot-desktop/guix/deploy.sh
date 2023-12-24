#!/usr/bin/env sh

# todo very interesting error messages when these two commands are run
#guix deploy deploy.scm -x -- '$@'
guix deploy deploy.scm -x -- "$@"
