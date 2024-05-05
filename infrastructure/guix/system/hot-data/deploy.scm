(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "hot-data.lan.hot.griffinht.com")
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxCY3LjStHUERybxBFvjYLXZvUDkLKl3C55ZeynZpHH")))))
