#!/bin/sh

set -xe

dir="$(mktemp -d)"
cd "$dir"
git init .
echo hi > bruh
git add .
git commit -m "initial commit"
git remote add origin ssh://127.0.0.1:2222/repo
git push --set-upstream origin master
