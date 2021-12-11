FROM debian:bullseye

#VOLUME cloudflare-dynamic
ENTRYPOINT [ "entrypoint.sh" ]

RUN apt-get update && apt-get install -y curl

COPY cloudflare-dynamic.sh .
COPY entrypoint.sh .
RUN chmod u+x cloudflare-dynamic.sh && chmod u+x entrypoint.sh