#!/bin/bash

# https://forum.mikrotik.com/viewtopic.php?t=94355
ssh-keygen -if mikrotik_rsa.pub -m PKCS8 | ssh-keygen -lf -
