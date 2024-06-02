#!/bin/sh

set -xe

dir="$(mktemp -d)"
cd "$dir"
git init .
echo hi > bruh
git add .
git commit -m "initial commit"
git remote add origin git://127.0.0.1/repo
git push --set-upstream origin master
