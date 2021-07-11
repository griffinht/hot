#!/bin/bash

: \
# Name of git repo to be cloned
&& export GIT_REPOSITORY=hot \
# Path to script to run after setup is complete
&& export SCRIPT=setup/init.sh \

# GitHub user to clone $GIT_REPOSITORY from
&& export GITHUB_USER=stzups \
# GitHub email to generate ssh key for
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
&& export GITHUB_EMAIL=griffinht@gmail.com \

#
# Setup script to be ran manually to clone a GitHub repo and start an init script
#

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
&& git clone git@github.com:$GITHUB_USER/$GITHUB_REPOSITORY.git . \

# execute $SCRIPT
&& chmod +x $SCRIPT \
&& ./$SCRIPT
