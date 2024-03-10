(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "guix-vm.wg.griffinht.com")
                         (host-name "192.168.0.6")
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOay9Mz5klPe0VdJRxzCx1juclU0TtEJOFc4Ieqt9Po")
                         ;; private key of host machine to authenticate with
                         ;; leave default its fine i think
                         ;;(identity "id_ed25519.pub")
                         ))))
