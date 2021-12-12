FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=stzups/griffin.ht:latest /griffin.ht/ /griffin.ht/
COPY --from=stzups/griffinht.com:latest /griffinht.com/ /griffinht.com/
RUN echo "helo there" > /scribbleshare.com/index.html