; full guix operating system which can be deployed with guix deploy to target which is already running guix
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         ;; this is the domain or ip address of the target machine
                         ;(host-name "hot-desktop.wg.hot.griffinht.com")
                         (host-name "hot-desktop.lan.hot.griffinht.com")
                         ;(host-name "localhost")
                         ;; why is system required?
                         (system "x86_64-linux")
                         ;; what user to login as, default root
                         (user "root")
                         ;; ssh public key of remote system
                         ;; obtain with `ssh-keyscan -p 2222 hostname`
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNlvI2uHIBUfgnbgU+p2uaM2y0/1dzHfGmN+Ii/LW2z")
                         ;; private key of host machine to authenticate with
                         ;; leave default its fine i think
                         ;;(identity "id_ed25519.pub")
                         ))))
