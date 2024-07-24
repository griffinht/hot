#!/bin/sh

set -xe

tag=iperf
publish_tag=docker.io/griffinhtdocker/iperf:latest

build() {
    guix pack \
        --manifest=manifest.scm \
        --format=docker \
        --image-tag="$tag" \
        -C none
}

# todo add EXPOSE 5201
# and maybe start the server by default? idk

file="$(build)"
docker load < "$file"
docker tag "$tag" "$publish_tag"
docker image rm "$tag"

#docker push "$publish_tag"
#docker image rm "$publish_tag"