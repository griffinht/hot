#!/bin/sh

set -xe

name="$1"
./sync.sh
./cloudtest.sh kill --signal=SIGHUP "$name"
./cloudtest.sh logs "$name"
