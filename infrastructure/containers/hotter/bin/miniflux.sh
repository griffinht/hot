#!/bin/sh

ssh -L 127.0.0.1:8080:flydfsg.internal:8080 -N "${SSH_HOST?}"
