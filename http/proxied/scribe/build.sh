#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

GIT_REF='1dcded9153c482553538fdf9a4f80e7d9361b19c'
SHA256='eea6614d566aebe22f575722f967a6779ff13715b47261f0023d7fda1d2eff90  tar.gz'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source
    exit 1
fi

docker build --tag scribe .
