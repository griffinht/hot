!#/bin/sh

apk add curl

curl -L https://github.com/hacdias/webdav/releases/download/v4.1.1/linux-amd64-webdav.tar.gz | tar -xz

mv webdav /usr/local/bin/webdav
