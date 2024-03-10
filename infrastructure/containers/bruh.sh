#!/bin/sh

#broken lol?
#podman image scp localhost/web:latest podmanrootless::

#podman image save localhost/web:latest | ssh podman@cloudtest.lan.griffinht.com podman image load
#podman --connection podmanrootless kube play web.yml
podman --connection podmanrootless kube play --replace web.yml
