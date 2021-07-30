#!/bin/bash

ssh-keygen -if mikrotik_rsa.pub -m PKCS8 | ssh-keygen -lf -
