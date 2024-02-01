(use-modules (griffinht util))
;(add-to-load-path (string-append (dirname (current-filename)) "/"))
;(use-modules (system))
; full guix operating system which can be deployed with guix deploy to target which is already running guix
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(list
  (machine
    ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
    (operating-system (load "system.scm"))
    (environment managed-host-environment-type)
    (configuration
      (machine-ssh-configuration 
        ;; this is the domain or ip address of the target machine
        (host-name "127.0.0.1")
        ;; why is system required?
        (system "x86_64-linux")
        ;; ssh public key of remote system
        ;; obtain with `ssh-keyscan -p 2222 hostname`
        (host-key (ssh-keyscan "127.0.0.1" "2222" "ed25519"))
        ;; private key of host machine to authenticate with
        ;; leave default its fine i think
        ; todo change to something idk
        ;;(identity "id_ed25519.pub")
        ;; ssh server port of remote system, default 22
        (port 2222)))))
        ;(port 22)))))
