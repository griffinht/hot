#!/bin/bash
# generate ssh key for use with github
# add the public key (printed with cat) to a single repository as a deploy key, with no write permissions
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "griffinht@gmail.com" && cat ~/.ssh/id_ed25519.pub
# after adding the public key to github, clone
git clone git@github.com:stzups/hot.git && cd hot && chmod -R +x ubuntu && sudo ubuntu/init.sh
