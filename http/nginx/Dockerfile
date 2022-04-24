FROM nginx:alpine@sha256:efc09388b15fb423c402f0b8b28ca70c7fd20fe31f8d7531ae1896bbb4944999

COPY --from=stzups/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=stzups/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=stzups/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
