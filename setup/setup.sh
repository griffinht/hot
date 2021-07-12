#!/bin/bash

: \
# Name of git repo to be cloned
&& GIT_REPOSITORY=hot \
# Path to script to run after setup is complete
&& SCRIPT=setup/init.sh \

# GitHub user to clone $GIT_REPOSITORY from
&& GITHUB_USER=stzups \
# GitHub email to generate ssh key for
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
&& GITHUB_EMAIL=griffinht@gmail.com \

#
# Setup script to be ran manually to clone a GitHub repo and start an init script
#

# fetch SSH key & fingerprint via SSH
&& SSH_HOST=github.com
&& SSH_KEY=$(ssh_keyscan $SSH_HOST) \
&& SSH_FINGERPRINT=$(ssh-keygen -lf $SSH_KEY) \
# fetch SSH fingerprint via HTTPS
&& HTTPS_URL=api.github.com/meta \
&& HTTPS_FINGERPRINT=$(curl -s https://$SSH_HOST | grep RSA) \
# verify fingerprints match
&& MESSAGE="$SSH_FINGERPRINT (fetched via ssh from $SSH_HOST)\n$HTTPS_FINGERPRINT (fetched via https from https://$HTTPS_URL)\n" \
&& if [[ SSH_FINGERPRINT != HTTPS_FINGERPRINT ]]; then \
# no match
  printf "SSH fingerprints do not match! MITM attack?\n$MESSAGE" && exit \
fi \
# match
&& printf "SSH fingerprints match\n$MESSAGE" \
# add verified SSH key to known_hosts
&& $SSH_KEY >> ~/.ssh/known_hosts \
# change to correct directory
&& mkdir $GIT_REPOSITORY \
&& cd $GIT_REPOSITORY \

# generate a deploy key for GitHub
&& ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C $GITHUB_EMAIL \
&& printf "\n$USER public key:" \
&& cat ~/.ssh/id_ed25519.pub \
&& printf "Add this key to GitHub as a deploy key for repository $GIT_REPOSITORY\n" \
&& read -p "Press enter to continue and clone repository $GIT_REPOSITORY from GitHub" \

# clone to current directory, which was changed to earlier
&& git clone git@$SSH_HOST:$GITHUB_USER/$GITHUB_REPOSITORY.git . \

# execute $SCRIPT
&& chmod +x $SCRIPT \
&& ./$SCRIPT
