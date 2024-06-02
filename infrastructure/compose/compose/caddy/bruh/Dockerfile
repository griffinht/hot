FROM alpine

RUN apk add caddy entr python3 jq webhookh

COPY bruh.sh /usr/bin/bruh.sh

ENTRYPOINT ["bruh.sh"]
