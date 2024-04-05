#!/bin/sh

echo "this script is from a test and should not be used"
echo "these rules can be dangerous if you don't understand them"
exit 1

set -xe

iptables -P INPUT DROP

iptables -A INPUT -i lo -j ACCEPT # Allow anything from loopback
iptables -A INPUT -i wg0 -j ACCEPT # Allow anything from wg0

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT # Allow established connections

iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT # Allow ICMP
# todo use multiport
iptables -A INPUT -p tcp --dport 22 -j ACCEPT # Allow SSH
iptables -A INPUT -p udp --dport 51820 -j ACCEPT # Allow wireguard

#built in chain, so its probably better to do iptables -P INPUT DROP instead of this
#iptables -A INPUT -j DROP # Drop eveything else




# very broken, does not work
#not a built in chain, so we can't do this
#iptables -P DOCKER-USER DROP

iptables -A DOCKER-USER -i lo -j RETURN # Allow anything from loopback
iptables -A DOCKER-USER -i wg0 -j RETURN # Allow anything from wg0

iptables -A DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN # Allow established connections
iptables -I DOCKER-USER -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# todo use multiport
iptables -A DOCKER-USER -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j RETURN # Allow HTTP
iptables -A DOCKER-USER -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j RETURN # Allow HTTPS
iptables -A DOCKER-USER -i eth0 ! -o docker0 -m conntrack --ctstate NEW -j DROP
iptables -A DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A DOCKER-USER -j DROP # Drop eveything else
# docker will insert a RETURN rule here which will never happen
