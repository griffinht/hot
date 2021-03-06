#!/bin/sh

apk add curl

# purpurmc 
curl https://api.purpurmc.org/v2/purpur/1.18/latest/download > /usr/local/bin/server.jar

# rcon-cli
curl -L https://github.com/itzg/rcon-cli/releases/download/1.5.1/rcon-cli_1.5.1_linux_amd64.tar.gz | tar -xz 
cp rcon-cli /usr/local/bin/rcon-cli
chmod +x /usr/local/bin/rcon-cli

# ttyd
curl -L https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 > /usr/local/bin/ttyd
chmod +x /usr/local/bin/ttyd

