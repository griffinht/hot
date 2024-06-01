#!/bin/bash

# set -x
set -eu
set -o pipefail

deploy_file="${DEPLOY_FILE?please set DEPLOY_FILE}"
program_name=deploy.sh

upgrade() {
    old_version="$1"
    new_version="$2"
    command upgrade "$old_version" "$new_version"
}

commit_deploy() {
    echo "$1" > "$deploy_file"
}

deploy() {
    new_version="$1"
    shift
    old_version="$(cat "$deploy_file" || (echo try "$program_name" init instead > /dev/stderr && exit 1))"
    (upgrade "$old_version" "$new_version" || (echo deploy from "$old_version" to "$new_version" failed with code "$?" > /dev/stderr && exit 1))
    echo upgraded from "$old_version" to "$new_version"
    if [ "$#" -gt 0 ] && [ "$1" = "--no-commit" ]; then
        echo warning: not committing update
    else
        echo committing...
        commit_deploy "$new_version"
    fi
}

init() {
    if [ -f "$deploy_file" ]; then
        echo program has already been initialized to version "$(cat "$deploy_file")" at "$deploy_file"
        return 1
    fi
    version="${1?what version do you to start with? maybe version 0?}"
    commit_deploy "$version"
}

"$@"
