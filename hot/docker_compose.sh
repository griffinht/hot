#!/usr/bin/env sh

EXIT=0

for dir in proxied/*; do
    (
    cd $dir
    if ! docker compose $@; then
        EXIt=1
    fi
    )
done

exit $EXIT
