(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "127.0.0.1")
                         (port 2222)
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7sXKSJly1wOeubq8RBpR3sVYoVLlBlUME+yS3Bw3uL")))))
