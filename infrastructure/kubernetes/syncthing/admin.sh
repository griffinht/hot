#!/bin/sh

port=8385
echo http://localhost:$port
ssh -L 127.0.0.1:$port:localhost:8384 root@hot.lan.hot.griffinht.com
