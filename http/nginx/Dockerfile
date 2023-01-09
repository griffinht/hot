FROM nginx:alpine@sha256:0f4e03e4e0e854bafe7ce689a4c2476feb07a88a465bbc7d0f155dd89a6b00db

COPY --from=griffinht/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=griffinht/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=griffinht/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
