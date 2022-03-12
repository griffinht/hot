FROM golang:alpine as build

RUN apk add make gcc musl-dev curl

WORKDIR /usr/src

RUN curl -L https://github.com/emersion/hydroxide/releases/download/v0.2.21/hydroxide-0.2.21.tar.gz | tar --strip-components=1 -xz \
  && go build ./cmd/hydroxide \
  && mv hydroxide /usr/local/bin/hydroxide

FROM alpine

RUN apk --no-cache add ca-certificates openrc \
    && rm -rf /var/cache/apk/*

COPY --from=build /usr/local/bin/hydroxide /usr/local/bin/hydroxide

ENTRYPOINT ["hydroxide", "-smtp-host", "0.0.0.0", "-imap-host", "0.0.0.0", "-carddav-host", "0.0.0.0"] 
