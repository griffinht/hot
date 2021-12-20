ssh user@192.168.0.1

# http with nat hairpin
#https://help.mikrotik.com/docs/display/ROS/NAT#NAT-HairpinNAT
#https://forum.mikrotik.com/viewtopic.php?t=172380
ip firewall nat add chain=dstnat action=dst-nat dst-address=98.21.46.184 dst-port=443 to-addresses=192.168.0.5 protocol=tcp
ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.5 out-interface-list=LAN protocol=tcp src-address=192.168.0.0/24

# wireguard (on port 123 to circumvent port blocking)
ip firewall nat add chain=dstnat action=dst-nat dst-address=98.21.46.184 dst-port=3108 to-addresses=192.168.0.5 protocol=udp
