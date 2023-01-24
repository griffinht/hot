FROM nginx:alpine

COPY --from=griffinht/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=griffinht/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=griffinht/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
