FROM alpine as build

ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip rclone.zip

RUN unzip rclone.zip && \
  mv rclone-*/rclone /rclone

FROM alpine

COPY --from=build /rclone /usr/local/bin/rclone

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]