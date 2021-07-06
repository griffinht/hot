#!/bin/bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "griffinht@gmail.com" && cat ~/.ssh/id_ed25519.pub
git clone git@github.com:stzups/hot.git && cd hot && chmod -R +x ubuntu && sudo ubuntu/init.sh
