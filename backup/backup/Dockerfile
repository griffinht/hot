FROM debian

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /backups

ENTRYPOINT ["/entrypoint.sh"]