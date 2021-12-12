FROM debian:bullseye

#VOLUME cloudflare-dynamic
ENTRYPOINT [ "./entrypoint.sh" ]

RUN apt-get update && apt-get install -y curl jq

COPY cloudflare.sh .
COPY entrypoint.sh .
RUN chmod u+x cloudflare.sh && chmod u+x entrypoint.sh