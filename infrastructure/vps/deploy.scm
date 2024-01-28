(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (system))

(list (machine
        (operating-system %system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration 
                         (host-name "nerd-vps.griffinht.com")
                         (system "x86_64-linux")
                         (user "root")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKa/xnHWjnxt5pxxt4NYAHPQXhTnWdiMltwSAn4H1NGR")
                         (port 22)))))
