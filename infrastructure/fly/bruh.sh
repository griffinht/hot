#!/bin/sh

shell.sh . -- flyctl wireguard create fly.conf
scp fly.conf hotter.griffinht.com:/etc/wireguard
ssh hotter.griffinht.com sh -c 'systemctl enable wg-quick@fly.service && systemctl start wg-quick@fly.service'
