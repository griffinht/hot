FROM debian:bullseye

RUN apt-get update \
  && apt-get install -y \
    cron \
    certbot \
    python3-certbot-dns-cloudflare

COPY certbot.sh .
COPY certbot-cron .
RUN chmod u+x certbot.sh \
  && chmod u+x certbot-cron \
  && crontab certbot-cron

VOLUME certbot

CMD [ "cron", "-f" ]
