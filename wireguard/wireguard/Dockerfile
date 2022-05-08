FROM alpine as build

RUN apk add --no-cache shellcheck

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN shellcheck /usr/local/bin/*

FROM alpine

RUN apk add --no-cache wireguard-tools

COPY --from=build /usr/local/bin/* /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
