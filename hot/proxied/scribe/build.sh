#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

#todo broken

GIT_REF='761e4ef170da87a36160a024e1cf1a1275751b56'
SHA256='326e77a96ef586174d2c00bdf4b76dc812a1bec8e4cc0e4271915c95a722ed85  tar.gz'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source, 
    echo "$SHA256" given, actual:
    sha256sum tar.gz
    exit 1
fi

docker build --tag scribe .
