FROM foxcpp/maddy:v5@sha256:61a4431a7a1582b60f70e9ad452dd1014b0455d3318b0beda76ef4f7a8a3167c

# also used for maddyctl
ENV MADDY_CONFIG=/etc/maddy/maddy.conf
COPY maddy /etc/maddy

# /bin/maddy should use $MADDY_CONFIG but it doesn't so a shell is needed to read that var
ENTRYPOINT ["sh", "-c", "maddy -config $MADDY_CONFIG"]
