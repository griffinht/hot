#!/bin/sh

set -e

#repository=git://git:9418/repo
repository=git://localhost:9418/repo

dir="$(mktemp -d)"
git clone "$repository" "$dir"

cleanup() {
    rm -rf "$dir"
}
trap cleanup EXIT

(
cd "$dir"

./ci/run
)
