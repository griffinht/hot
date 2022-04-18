FROM alpine

RUN apk add --no-cache restic

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
