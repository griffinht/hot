#!/bin/sh

peer='gw5LGcb/Wfgambnv3UuPxO/zmQsPr+v6mHzZuGhWPnk='

ssh nerd-vps.wg.hot.griffinht.com << 'EOF'
wg show wg0 endpoints
EOF
    grep "$peer"
