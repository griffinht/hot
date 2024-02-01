#!/bin/sh

set -e

# localhost does not work for podman because of ssh known hosts issue
host="ssh://docker@127.0.0.1:2222"

docker() {
    DOCKER_HOST="$host" guix shell docker-cli -- ./test.sh docker
}

podman() {
    # todo configure container policy
    known_hosts="$(mktemp)"
    ssh-keyscan -p 2222 127.0.0.1 > "$known_hosts"
    CONTAINER_HOST="$host" \
        CONTAINER_SSHKEY="$HOME/.ssh/id_ed25519" \
        guix shell --container \
        --preserve=CONTAINER_HOST \
        "--share=$known_hosts=$HOME/.ssh/known_hosts" \
        "--expose=$HOME/.ssh/id_ed25519" \
        --network \
        podman openssh
        #podman openssh -- ./test.sh podman-remote
        #podman openssh -- ssh -p 2222 docker@127.0.0.1
}

podman
