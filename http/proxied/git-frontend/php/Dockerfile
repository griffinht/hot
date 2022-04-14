FROM php:8.1-fpm-alpine

ARG VERSION=2.0.0

WORKDIR /var/www/gitlist

RUN apk add curl \
    && curl -L https://github.com/klaussilveira/gitlist/releases/download/"$VERSION"/gitlist-"$VERSION".zip > zip \
    && unzip -q zip \
    && rm -r zip \
    && mkdir -p var/cache \
    && mkdir -p var/log \
    && chmod -R 777 var
