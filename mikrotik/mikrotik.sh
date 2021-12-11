ssh user@192.168.0.1

ip firewall nat add chain=dstnat action=dst-nat dst-address=98.21.46.184 dst-port=443 to-addresses=192.168.0.254 protocol=tcp
ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.254 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24