FROM nginx:alpine

COPY --from=stzups/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=stzups/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=stzups/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
