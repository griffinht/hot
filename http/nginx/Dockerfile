FROM nginx:alpine@sha256:186c79dc14ab93e43d315143ee4b0774506dc4fd952388c20e35d3d37058ab8d

COPY --from=griffinht/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=griffinht/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=griffinht/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
