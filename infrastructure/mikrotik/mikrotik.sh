#!/usr/bin/env sh

#https://wiki.mikrotik.com/wiki/Manual:Securing_Your_Router
#https://libreddit.hot.griffinht.com/r/mikrotik/comments/pflvc2/how_do_i_reserve_a_specific_static_ip_for_a_device/

cat << EOF
# leave only ssh
/ip service disable telnet,ftp,www,www-ssl,api,winbox,api-ssl

# static local dns
/ip dns static add name=lil-tik.lan.griffinht.com address=192.168.0.1
#/ip dns static add name=fruit-pi.lan.griffinht.com address=192.168.0.2
#/ip dns static add name=tp-wap.lan.griffinht.com address=192.168.0.3
/ip dns static add name=hot-desktop.lan.griffinht.com address=192.168.0.5
/ip dns static add name=envy-laptop.lan.griffinht.com address=192.168.0.6

#something like this
#todo static dhcp lease
#/ip dhcp-server lease make-static
#
#192.168.0.1 lil-tik static
#192.168.0.2 fruit-pi static
#/ip dhcp-server lease add address=192.168.0.3 mac-address=E4:11:5B:61:70:DD server=defconf
#/ip dhcp-server lease add address=192.168.0.5 mac-address=fc:aa:14:b0:1b:64 server=defconf
/ip dhcp-server lease add address=192.168.0.6 mac-address=E4:11:5B:61:70:DD server=defconf

# dynamic dns for hairpin nat external ip
/ip firewall address-list add address=windy.griffinht.com list=WANIP

# hairpin nat
#https://help.mikrotik.com/docs/display/ROS/NAT#NAT-HairpinNAT
#https://forum.mikrotik.com/viewtopic.php?t=172380
/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.6 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24

# nginx
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=80 to-addresses=192.168.0.6 protocol=tcp
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=443 to-addresses=192.168.0.6 protocol=tcp
# wireguard
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51820 to-addresses=192.168.0.6 protocol=udp
# wire2
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51821 to-addresses=192.168.0.5 protocol=udp




EOF


#away
#ip dns static add name=big-tik.lan.griffinht.com address=192.168.0.1
#ip dns static add name=tp2-wap.lan.griffinht.com address=192.168.0.4
