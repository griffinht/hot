(list (machine
        ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
        (operating-system (load "system.scm"))
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         ; todo
                         ;(host-name "127.0.0.1")
                         ;(port 2223)
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICA+tIVnsULH14G2k/Q0Dl4a0jfLpZ/5737rs21iIRx+")))))
