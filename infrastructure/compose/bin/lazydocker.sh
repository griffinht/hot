#!/bin/sh

echo todo what is this
exit 1
docker run \
    --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    lazyteam/lazydocker
