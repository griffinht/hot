#!/bin/sh

# install chasquid binaries to /usr/local/bin/
# currently this includes the following:
# chasquid chasquid-util smtp-check mda-lmtp
#
# also see https://blitiri.com.ar/p/chasquid/install/
#
# dependencies
# apk add curl make go
#
# currently install from github tarball because git clone via HTTP dumb transport from author's cgit repo is slow and downloads the entire git history instead of the source code of a commit


BRANCH="$BRANCH"
# github mirror is used because author's cgit repo https://blitiri.com.ar/repos/chasquid only supports git clone via HTTP dumb transport which is slow
URL="https://github.com/albertito/chasquid/archive/refs/tags/$BRANCH.tar.gz"

curl -L "$URL" > chasquid.tar.gz

# curl -L "$URL" | sha256sum
SHA256='84f2429e17832d3c381045bf600d47dc88d3b3f94b070307aa1b5e484e0694e6'

# check integrity of source
if ! echo "$SHA256  chasquid.tar.gz" | sha256sum -c; then
    echo "integrity compromised of $URL"
    exit 1
fi

mkdir chasquid
cd chasquid
tar -xz --strip-components=1 < ../chasquid.tar.gz
make

# Install the binaries to /usr/local/bin.
make install-binaries
