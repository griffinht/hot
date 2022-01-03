FROM debian

RUN apt-get update && apt-get install -y curl

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/8fcecd59a0fd991f1fb4248692af63889bb90d81/acme.sh /usr/local/bin/acme.sh


RUN chmod +rx /usr/local/bin/acme.sh && \
    useradd -m acme && \
    mkdir /certificates && \
    chown acme: /certificates


WORKDIR /home/acme

COPY --chown=acme:acme entrypoint.sh .
COPY --chown=acme:acme acme.sh acme.sh
ADD --chown=acme:acme https://raw.githubusercontent.com/acmesh-official/acme.sh/8fcecd59a0fd991f1fb4248692af63889bb90d81/dnsapi/dns_cf.sh /home/acme/.acme.sh/dnsapi/
ADD --chown=acme:acme https://raw.githubusercontent.com/acmesh-official/acme.sh/8fcecd59a0fd991f1fb4248692af63889bb90d81/dnsapi/dns_aws.sh /home/acme/.acme.sh/dnsapi/

RUN chmod +x entrypoint.sh && \
    chmod +x acme.sh

USER acme
ENTRYPOINT ["./entrypoint.sh"]