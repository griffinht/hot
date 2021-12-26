FROM place1/wg-access-server

VOLUME ["/data"]

COPY entrypoint.sh /entrypoint.sh
COPY config.yaml /config.yaml

ENTRYPOINT ["/entrypoint.sh"]