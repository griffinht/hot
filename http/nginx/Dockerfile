FROM nginx:alpine@sha256:0f2ab24c6aba5d96fcf6e7a736333f26dca1acf5fa8def4c276f6efc7d56251f

COPY --from=griffinht/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=griffinht/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=griffinht/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
