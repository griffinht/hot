(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "nerd-vps.wg.hot.griffinht.com")
                         ;(host-name "nerd-vps.griffinht.com")
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKa/xnHWjnxt5pxxt4NYAHPQXhTnWdiMltwSAn4H1NGR")))))
