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
URL="https://github.com/albertito/chasquid/"

git clone --branch "$BRANCH" "$URL" chasquid
# idk if git rev-parse is cryptographically strong
# todo find a diff way to check integrity
# also tar -c | sha256sum doesn't work because git clone uses current last modified which changes hash
SHA1='1a7c1cf60c1c058e2f1708d6f487fa70a73ab5d7'

cd chasquid

# check integrity of source
if [ "$SHA1" != "$(git rev-parse $BRANCH)" ]; then
    echo "integrity compromised of $URL"
    exit 1
fi

# compiling chasquid requires the git repository to get the version or something
# otherwise an error will occur
# panic: strconv.ParseInt: parsing "": invalid syntax
#make

# Install the binaries to /usr/local/bin.
make install-binaries
