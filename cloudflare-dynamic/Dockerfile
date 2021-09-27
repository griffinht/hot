FROM debian:bullseye

RUN apt-get update \
  && apt-get install -y \
    cron \
    curl

COPY cloudflare-dynamic.sh .
COPY cloudflare-dynamic-cron .
RUN chmod u+x cloudflare-dynamic.sh \
  && chmod u+x cloudflare-dynamic-cron \
  && crontab cloudflare-dynamic-cron

VOLUME cloudflare-dynamic

#CMD [ "cron", "-f" ]
CMD [ "/bin/bash", "cloudflare-dynamic.sh" ]