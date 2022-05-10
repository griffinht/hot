#!/usr/bin/env sh

DIR="$(mktemp -d)"
cd "$DIR" || exit 1

GIT_REF='defec9319e7e42ac72ffb3674f147f1a4ea92eb4'
SHA256='cdbd5a3e841aeeceec43f85afed602f22b0e4dbe37ca0fbc6bbedd0b49e6fd16'

if ! (curl "https://git.sr.ht/~edwardloveall/scribe/archive/$GIT_REF.tar.gz" > tar.gz \
    && echo "$SHA256  tar.gz" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz); then
    echo failed to download and verify source
    exit 1
fi

docker build --tag scribe .
