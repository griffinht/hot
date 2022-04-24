FROM alpine

RUN apk add --no-cache iperf3 \
  && adduser -S iperf

USER iperf
   
ENTRYPOINT ["iperf3"]

# run in server mode by default
CMD ["-s"]
