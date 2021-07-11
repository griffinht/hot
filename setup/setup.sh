#!/bin/bash

# Setup script to be ran manually to clone the Github repo and start the actual init script

mkdir hot \
&& cd hot \
&& ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "griffinht@gmail.com" \
&& echo "Administrator public key:" \
&& cat ~/.ssh/id_ed25519.pub \
&& echo "Add this key to Github as a deploy key for a single repository" \
&& read -p "Press any key to continue and clone the Github repository" \
&& git clone git@github.com:stzups/hot.git . \
&& chmod +x setup/init.sh \
&& ./setup/init.sh
