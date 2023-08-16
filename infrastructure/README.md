todo dns!
https://www.youtube.com/watch?v=7MWhwdbKW5c
update dns record, then ci tests to make sure dns is correct???
but also whats the point if we know its correct :/

local tests if you really want them
point the tests at a guix machine






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
    lan - (lil-tik static dns on 192.168.0.1)
        lil-tik     192.168.0.1
        hot-desktop 192.168.0.5
        envy-laptop 192.168.0.6

    wg (dnsmasq on 10.0.0.1)
        envy-laptop     10.0.0.1
        hot-desktop     10.0.0.2
        nerd-vps        10.0.0.3
        smart-laptop    10.0.0.4
        phone           10.0.0.5
        other-phone     10.0.0.6
