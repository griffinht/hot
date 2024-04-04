#!/bin/sh

set -xe

dir="$(mktemp -d)"
cd "$dir"
git clone git://127.0.0.1/repo .
git commit --allow-empty -m "bruh"
git push --set-upstream origin master
