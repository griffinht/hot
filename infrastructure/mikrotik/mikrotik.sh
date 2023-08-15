#!/usr/bin/env sh

#ssh user@192.168.0.1

HOST=192.168.0.6
EXTERNAL_ADDRESS=98.21.42.147

cat << EOF
# http with nat hairpin
#https://help.mikrotik.com/docs/display/ROS/NAT#NAT-HairpinNAT
#https://forum.mikrotik.com/viewtopic.php?t=172380
ip firewall nat add action=masquerade chain=srcnat dst-address=$HOST out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24
# nginx
ip firewall nat add chain=dstnat action=dst-nat dst-address=$EXTERNAL_ADDRESS dst-port=80 to-addresses=$HOST protocol=tcp
ip firewall nat add chain=dstnat action=dst-nat dst-address=$EXTERNAL_ADDRESS dst-port=443 to-addresses=$HOST protocol=tcp

# wireguard
ip firewall nat add chain=dstnat action=dst-nat dst-address=$EXTERNAL_ADDRESS dst-port=51820 to-addresses=$HOST protocol=udp

# smtp
ip firewall nat add chain=dstnat action=dst-nat dst-address=$EXTERNAL_ADDRESS dst-port=25 to-addresses=$HOST protocol=tcp
EOF

exit
#!/bin/bash

# https://forum.mikrotik.com/viewtopic.php?t=94355
ssh-keygen -if mikrotik_rsa.pub -m PKCS8 | ssh-keygen -lf -

