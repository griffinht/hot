FROM nginx:alpine@sha256:e012f7b78c91f50a8a98bec1b707e454f783c5cbc5a8caeaadce60b3d143b70f

COPY --from=griffinht/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=griffinht/griffinht.com:latest /griffinht.com/ /griffinht.com/
COPY --from=griffinht/stzups.net:latest /stzups.net/ /stzups.net/

COPY hot/ /hot/

COPY ./nginx/ /etc/nginx
