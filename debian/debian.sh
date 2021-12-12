#!/bin/bash

sudo sysctl net.ipv4.ip_unprivileged_port_start=80
docker run -v "$(pwd)"/preseed:/usr/share/nginx/html/preseed -p 80:80 nginx

# curl http://localhost/preseed