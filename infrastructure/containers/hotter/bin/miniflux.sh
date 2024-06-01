#!/bin/bash

host='127.0.0.1:8080'

linkify "http://$host"

ssh -L "$host:localhost:80" -N "${SSH_HOST?}"
