https://www.mail-archive.com/help-guix@gnu.org/msg11102.html
https://issues.guix.gnu.org/48314



                                ; CURRENTLY BROKEN
                                ; https://issues.guix.gnu.org/64653
                                ; workaround is to use dhcp then switch to static-networking then switch back!?!?!
                                ; WORKAROUND: ip address add 192.168.0.6/24 dev eno1
                                ; basically static-networking breaks things on boot/restart of networking service
                                ; so use dhcp then redeploy with static networking then go back to dhcp
                                ; then the server magically listens from both interfaces lol i guess static networking doesn't clean up after itself
                                ;(service static-networking-service-type
                                ;         (list (static-networking
                                ;                (addresses
                                ;                 (list (network-address
                                ;                        (device "eno1")
                                ;                        (value "192.168.0.6/24"))))
                                ;                (routes
                                ;                 (list (network-route
                                ;                        (destination "default")
                                ;                        (gateway "192.168.0.1"))))
                                ;                (name-servers '("192.168.0.1"))))) ; todo what if i don't specify name servers?
