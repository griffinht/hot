#!/bin/sh

set -e

host="ssh://docker@localhost:2222"

docker() {
    DOCKER_HOST="$host" guix shell docker-cli -- ./test.sh docker
}

podman() {
    # todo configure container policy
    CONTAINER_HOST="$host" guix shell docker-cli -- ./test.sh podman
}

docker
