FROM filebrowser/filebrowser

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh && rm /.filebrowser.json

ENTRYPOINT ["./entrypoint.sh"]