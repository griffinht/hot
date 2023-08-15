todo google wireguard dns internal network

griffinht.com
    hot - 98.21.42.147 via dynamic ip
        192.168.0.1 router
        192.168.0.5 hot-desktop
        192.168.0.6 envy-laptop
    wg (provide alternate dns??)
        10.0.0.1 nerd-vps
        10.0.0.2 hot-desktop
        10.0.0.3 envy-laptop
        10.0.0.4 smart-laptop
        10.0.0.5 phone
        10.0.0.6 other-phone



griffinht.com
    todo what if dynamic ip was lost?
    todo mikrotik auto config scripts

    (root), hot, \*.hot - 98.21.42.147 (dynamic ip)
        :80 -> 192.168.0.6
        :443 -> 192.168.0.6
        :51820 -> 192.168.0.6
        (internet accessible via nat)
        (internally accessible via hairpin nat)
    nerd-vps - 198.46.248.168 (static ip)
        :22 (todo no internet??)
        :51820
    lan - (mikrotik static dns on 192.168.0.1)
        router      192.168.0.1
        hot-desktop 192.168.0.5
        envy-laptop 192.168.0.6

    wg (dnsmasq on 10.0.0.1)
        envy-laptop     10.0.0.1
        hot-desktop     10.0.0.2
        nerd-vps        10.0.0.3
        smart-laptop    10.0.0.4
        phone           10.0.0.5
        other-phone     10.0.0.6
