#!/bin/bash

host='127.0.0.1:8080'

ssh -L "$host:localhost:80" -N "${SSH_HOST?}"
