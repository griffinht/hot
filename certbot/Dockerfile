FROM debian:bullseye

COPY certbot.sh .
COPY bin/cloudflare.ini .
RUN chmod u+x certbot.sh \
  && apt-get update \
  && apt-get install -y \
    certbot \
    python3-certbot-dns-cloudflare \

VOLUME certbot

ENTRYPOINT [ "./certbot.sh" ]
