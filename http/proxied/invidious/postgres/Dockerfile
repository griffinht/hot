# invidious requires these script things
FROM alpine as build

RUN apk add --no-cache curl

WORKDIR /app/src

ARG SHA256="7e28da799eda7cdfb0bf6a081cf9b80fc4f81d832e954f24a0171e894c05445a"
ARG GIT_REF="da8a2c7bbbff47e1845c2bc339aae7f727f9ea18"

RUN curl -L https://github.com/iv-org/invidious/archive/$GIT_REF.tar.gz > tar.gz \
    && echo "$SHA256  tar.gz" | sha256sum -c \
    && tar -xz --strip-components=1 < tar.gz \
    && rm tar.gz

FROM postgres:alpine@sha256:2fb5718f2a23dbac9bd1258e886eee90250a5903785e3136d62dd65e19f34982

COPY --from=build /app/src/config/sql /config/sql
COPY --from=build /app/src/docker/init-invidious-db.sh /docker-entrypoint-initdb.d/init-invidious-db.sh
