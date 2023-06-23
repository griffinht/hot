FROM alpine

RUN apk add openssl

WORKDIR /lego/certificates

ADD entrypoint.sh /usr/local/bin

ENTRYPOINT ["entrypoint.sh"]

