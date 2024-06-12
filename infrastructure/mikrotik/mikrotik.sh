#!/usr/bin/env sh

#https://wiki.mikrotik.com/wiki/Manual:Securing_Your_Router
#https://libreddit.hot.griffinht.com/r/mikrotik/comments/pflvc2/how_do_i_reserve_a_specific_static_ip_for_a_device/

cat << EOF

# hairpin nat
#https://help.mikrotik.com/docs/display/ROS/NAT#NAT-HairpinNAT
#https://forum.mikrotik.com/viewtopic.php?t=172380

# masquerade fixes lan->external->lan thing
# dstnat is just regular external->lan

# hypervisor wireguard
/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.5 out-interface-list=LAN src-address=192.168.0.0/24
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51820 to-addresses=192.168.0.5 protocol=udp

# mystuff-guix wireguard
/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.8 out-interface-list=LAN src-address=192.168.0.0/24
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51821 to-addresses=192.168.0.8 protocol=udp
EOF
