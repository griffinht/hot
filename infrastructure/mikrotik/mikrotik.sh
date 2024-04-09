#!/usr/bin/env sh

#https://wiki.mikrotik.com/wiki/Manual:Securing_Your_Router
#https://libreddit.hot.griffinht.com/r/mikrotik/comments/pflvc2/how_do_i_reserve_a_specific_static_ip_for_a_device/

cat << EOF
# leave only ssh
/ip service disable telnet,ftp,www,www-ssl,api,winbox,api-ssl
/snmp set enabled yes

# static local dns
/ip dns static add name=lil-tik.lan.hot.griffinht.com address=192.168.0.1
#/ip dns static add name=fruit-pi.lan.hot.griffinht.com address=192.168.0.2
/ip dns static add name=tp-wap.lan.hot.griffinht.com address=192.168.0.3
/ip dns static add name=hot-desktop.lan.hot.griffinht.com address=192.168.0.5
#/ip dns static add name=envy-laptop.lan.hot.griffinht.com address=192.168.0.6
/ip dns static add name=mystuff-guix.lan.hot.griffinht.com address=192.168.0.8
#todo? why not try ipv6?
#/ip dns static add name=mystuff-guix.lan.hot.griffinht.com type=AAAA address=fe80::5054:ff:fed4:ace9
/ip dns static add name=cloudtest.lan.hot.griffinht.com address=192.168.0.9

# dhcp leases
#192.168.0.1 lil-tik static
#192.168.0.2 fruit-pi static
#/ip dhcp-server lease add address=192.168.0.3 mac-address=E4:11:5B:61:70:DD server=defconf
# hot-desktop (hypervisor)
/ip dhcp-server lease add address=192.168.0.5 mac-address=fc:aa:14:b0:1b:64 server=defconf
# envy-laptop
/ip dhcp-server lease add address=192.168.0.6 mac-address=E4:11:5B:61:70:DD server=defconf
# terraria laptop
/ip dhcp-server lease add address=192.168.0.7 mac-address=04:7c:16:d1:b4:97 server=defconf
# mystuff-guix
/ip dhcp-server lease add address=192.168.0.8 mac-address=52:54:00:d4:ac:e9 server=defconf
# cloudtest
/ip dhcp-server lease add address=192.168.0.9 mac-address=52:54:00:ac:97:88 server=defconf




# dynamic dns for hairpin nat external ip
/ip firewall address-list add address=windy.griffinht.com list=WANIP

# hairpin nat
#https://help.mikrotik.com/docs/display/ROS/NAT#NAT-HairpinNAT
#https://forum.mikrotik.com/viewtopic.php?t=172380
/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.5 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24
#would need to be udp for wg????
#/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.6 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24





# hypervisor wireguard
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51820 to-addresses=192.168.0.5 protocol=udp
# mystuff-guix wireguard
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=51821 to-addresses=192.168.0.8 protocol=udp
# podmanrootless nginx
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=80 to-addresses=192.168.0.9 protocol=tcp
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=443 to-addresses=192.168.0.9 protocol=tcp



# terarria laptop
# todo remove this rule i don't think that it is necessary
/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.7 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24
# terraria
/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=7777 to-addresses=192.168.0.7 protocol=tcp
EOF


#away
#ip dns static add name=big-tik.lan.griffinht.com address=192.168.0.1
#ip dns static add name=tp2-wap.lan.griffinht.com address=192.168.0.4
