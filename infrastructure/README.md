# security
https://blog.miyuru.lk/setup-wireguard-with-global-ipv6/
https://www.hardill.me.uk/wordpress/2021/04/20/setting-up-wireguard-ipv6/

## networking
lan exposed ports
    use vlans, put most devices on an isolated network where they can't see anyone

container hosts (cloudtest) can reach all of my lan AND wireguard
    lan: solved by putting the whole vm on a vlan
        but i want to access some things from the vm host like network shares!
        solution: a real firewall lol
    host: anything bound to 0.0.0.0
    host: anything bound to loopback? maybe? todo test
    wireguard: everything! you need a firewall!


cool-laptop
nerd-vps firewall! would be a lot safer than hoping that everything is bound to 127.0.0.1...
    also consider exposed dhclient and stuff...
    not a problem for lan vms because we have mikrotik

wireguard clients with packet forwarding enabled can be accessed from any wireguard server!
todo:
    cloudtest can be reached by nerd
    my laptop might be reachable...


## updates/supply chain
todo auto update? todo ci git hash update keep everything in vcs instead of random versions
https://docs.docker.com/docker-hub/builds/
https://docs.docker.com/docker-hub/webhooks/


# secrets
there are a lot of random secrets
i think i really just need to write down where each secret is and how to rotate it

## cool-laptop
todo cool-laptop secrets
    use a passphrase on ssh key + agent + security token?
root:
- cool-laptop wireguard private key
user:
- ssh private key

## cloudtest
root:
- ssh host keys
docker volumes:
- monitoring_wireguard: cloudtest private wireguard key

## nerd-vm

    can i keep no secrets on here? its just a cloud machine i'd rather not have anything security related!
root:
- ssh host keys


# network overview

domain nameservers:
doug.ns.cloudflare.com
marjory.ns.cloudflare.com
#todo add your own! knot dns!
#todo add non cloudflare which works as slave! hurricane electric? im sure there are many others

griffinht.com
    windy -> (dynamic ip manually updated) todo auto update script
        see mikrotik.sh for port forwarding rules
        (internet accessible via nat)
        (internally accessible via hairpin nat)
    (root), hot, \*.hot -> windy 
    nerd-vps - 198.46.248.168 (static ip)
        :22 (todo remove internet access, allow only via wg???)
        :51820
    lan - (lil-tik static dns on 192.168.0.1 (actually might move this to fruit-pi??))
        see mikrotik.sh for static dns

        lil-tik     192.168.0.1
        fruit-pi    192.168.0.2
        tp-wap      192.168.0.3
        hot-desktop 192.168.0.5
        envy-laptop 192.168.0.6
        vm-guix     192.168.0.7

#todo read this interesting and very complex setup https://dev.to/tangramvision/what-they-don-t-tell-you-about-setting-up-a-wireguard-vpn-1h2g 
#todo rethink ip for conflicts! https://en.wikipedia.org/wiki/Reserved_IP_addresses
    wg (dnsmasq on 10.0.0.1) todo?
        #envy-laptop     10.0.0.1
        hot-desktop     10.0.0.2
        nerd-vps        10.0.0.3
        #smart-laptop    10.0.0.4
        #phone           10.0.0.5
        #other-phone     10.0.0.6
        #ugly-laptop     10.0.0.7
        cool-laptop     10.0.0.9
        cloudtest       10.0.0.10
