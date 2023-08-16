(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (system))

(list (machine
        (operating-system %system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "nerd-vps.griffinht.com")
                         (system "x86_64-linux")
                         (user "root")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsP1i8TV3+b/AiWidM5Yg5jMmkc/yfnMUG6yHFz+zfs")
                         (port 22)))))
