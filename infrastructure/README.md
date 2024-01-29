

todo auto update? todo ci git hash update keep everything in vcs instead of random versions
https://docs.docker.com/docker-hub/builds/
https://docs.docker.com/docker-hub/webhooks/


https://blog.miyuru.lk/setup-wireguard-with-global-ipv6/
https://www.hardill.me.uk/wordpress/2021/04/20/setting-up-wireguard-ipv6/



domain nameservers:
doug.ns.cloudflare.com
marjory.ns.cloudflare.com
#todo add your own! knot dns!
#todo add non cloudflare which works as slave! hurricane electric? im sure there are many others

griffinht.com
    windy -> (dynamic ip manually updated) todo auto update script
        :80 -> 192.168.0.6
        :443 -> 192.168.0.6
        :51820 -> 192.168.0.6
        (internet accessible via nat)
        (internally accessible via hairpin nat)
    (root), hot, \*.hot -> windy 
    nerd-vps - 198.46.248.168 (static ip)
        :22 (todo remove internet access, allow only via wg???)
        :51820
    lan - (lil-tik static dns on 192.168.0.1 (actually might move this to fruit-pi??))
        lil-tik     192.168.0.1
        fruit-pi    192.168.0.2
        tp-wap      192.168.0.3
        hot-desktop 192.168.0.5
        envy-laptop 192.168.0.6

#todo read this interesting and very complex setup https://dev.to/tangramvision/what-they-don-t-tell-you-about-setting-up-a-wireguard-vpn-1h2g 
#todo rethink ip for conflicts! https://en.wikipedia.org/wiki/Reserved_IP_addresses
    wg (dnsmasq on 10.0.0.1)
        envy-laptop     10.0.0.1
        hot-desktop     10.0.0.2
        nerd-vps        10.0.0.3
        smart-laptop    10.0.0.4
        phone           10.0.0.5
        other-phone     10.0.0.6
        ugly-laptop     10.0.0.7
        cool-laptop     10.0.0.9
