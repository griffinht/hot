(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (my-system))
; full guix operating system which can be deployed with guix deploy to target which is already running guix
; todo a lot of this is duplicated from bootstrap.scm why not do some scheme guile magic to avoid repeating myself
; too bad i don't really know guile
;(use-modules (gnu))
;(use-service-modules networking ssh)
;(use-package-modules bootloaders ssh)
;(define %bruh2 (include "./deploy.scm"))
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        ;(operating-system (include "./deploy.scm"))
        (operating-system my-system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         ;; this is the domain or ip address of the target machine
                         (host-name "localhost")
                         ;; why is system required?
                         (system "x86_64-linux")
                         ;; what user to login as, default root
                         (user "root")
                         ;; ssh public key of remote system
                         ;; note guix will use the host machine's known_hosts file
                         ;; guix also will not interactively prompt you to trust the new key
                         ;; thats why if you don't want to add to known_hosts?? does it add anyway
                         ;; then explicitly provide the identity file
                         ;; its easier to omit and use ~/.ssh/known_hosts
                         ;; just log in via ssh on the host machine to trust the key, then guix deploy
                         ;; actually this is deprecated and bad
                         ;; the right thing is to log in via ssh and then add the fingerprint
                         ;; todo configure via .env? shouldn't really be in vcs... actually maybe it should
                         ;; obtain with `ssh-keyscan -p 2222 hostname`
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLbUwHkKeHxZvOPTIOiN2LFGd/QGhbKT5+lRZ50Huyt")
                         ;; private key of host machine to authenticate with
                         ;; leave default its fine i think
                         ;;(identity "id_ed25519.pub")
                         ;; ssh server port, default 22
                         (port 2222)))))
