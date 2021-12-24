#!/bin/bash

rm .env
./certbot/configure.sh
./dynamic-ip/configure.sh