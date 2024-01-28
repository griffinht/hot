(define-module (system)
               #:use-module (gnu)
               #:use-module (gnu services networking) ; dhcp or static ip configuration
               #:use-module (gnu services vpn) ; wireguard
               #:use-module (gnu services ssh) ; ssh daemon
               ;#:use-module (gnu services admin) ; unattended upgrades
               #:use-module (gnu services desktop) ; elogind (for docker)
               ;#:use-module (gnu services dbus) ; dbus (for docker)
               ;#:use-module (gnu services docker) ; docker
               #:use-module (gnu packages bootloaders) ; grub
               #:use-module (gnu packages curl) ; curl
               #:use-module (gnu packages certs) ; nss-certs
               #:use-module (gnu packages ssh))

(define-public %system
               (operating-system
                 (host-name "nerd-vps")
                 (timezone "Etc/UTC")
                 (bootloader (bootloader-configuration
                              (bootloader grub-bootloader)))
                 ; fallocate --length=1G /swappy
                 ; todo doesn't work?????
                 (swap-devices (list (swap-space
                        (target "/swappy"))))
                 (file-systems (cons (file-system
                                       (mount-point "/")
                                       (device (file-system-label "Guix_image"))
                                       ;(device "/dev/vda2")
                                       (type "ext4"))
                               %base-file-systems))
                 (packages
                   (append (list nss-certs ; tls certs from mozilla, required for https to work
                                 curl ; helpful for occasional debugging
                                 )
                           %base-packages))
                 (services
                  (append (list (service dhcp-client-service-type)
                                (service openssh-service-type
                                         (openssh-configuration
                                          (openssh openssh-sans-x)
                                          (permit-root-login `prohibit-password)
                                          (password-authentication? #f)
                                          (authorized-keys
                                           `(("root" ,(local-file "id_ed25519.pub"))))))
                                (service elogind-service-type)) ; make shutdown work
                                ; todo https://www.procustodibus.com/blog/2022/11/wireguard-jumphost/
                                #|
                                (service wireguard-service-type
                                         (wireguard-configuration
                                           (addresses '("10.0.0.3/32"))
                                           (port 51820)
                                           (peers
                                             (list
                                               (wireguard-peer
                                                 (name "smart-laptop")
                                                 (public-key "V//LVPk6jLy6tQWxIyqDapeP7kj2bZ84YAsmCoigdQ4=")
                                                 (allowed-ips '("10.0.0.4/32")))
                                               )))))|#
                          (modify-services %base-services
                          ;; The server must trust the Guix packages you build. If you add the signing-key
                          ;; manually it will be overridden on next `guix deploy` giving
                          ;; "error: unauthorized public key". This automatically adds the signing-key.
                          (guix-service-type config =>
                                             (guix-configuration
                                              (inherit config)
                                              (authorized-keys
                                               (append (list (local-file "/etc/guix/signing-key.pub"))
                                                       %default-authorized-guix-keys)))))
                                      ))))
