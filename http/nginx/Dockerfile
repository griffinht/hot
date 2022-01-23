FROM nginx

COPY --from=stzups/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=stzups/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=stzups/stzups.net:latest /stzups.net/ /stzups.net/
COPY --from=stzups/realgmoney.com:latest /realgmoney.com/ /realgmoney.com/
COPY hot/ /hot/

COPY ./nginx/ /etc/nginx/