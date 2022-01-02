FROM debian:bullseye

ENTRYPOINT ["./entrypoint.sh"]

RUN apt-get update && apt-get install -y \
    certbot \
    python3-certbot-dns-cloudflare \
    python3-certbot-dns-route53

COPY entrypoint.sh .
COPY certbot.sh .
RUN chmod u+x entrypoint.sh && chmod u+x certbot.sh

