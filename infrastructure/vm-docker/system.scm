(define-module (system)
               #:use-module (gnu)
               #:use-module (gnu services networking)
               #:use-module (gnu services ssh)
               #:use-module (gnu services sysctl)
               #:use-module (gnu services vpn)
               #:use-module (gnu services desktop)
               #:use-module (gnu packages ssh))
(define-public (make-system ssh-public-key wireguard-public-key)
               (operating-system
                 (host-name "vm-docker")
                 ;todo remove timezone not necessary? defaults are fine?
                 (timezone "Etc/UTC")
                 (bootloader (bootloader-configuration (bootloader grub-bootloader)))
                 (file-systems %base-file-systems)
                 ; https://issues.guix.gnu.org/34255
                 ; note the swap file must be manually created
                 ; fallocate --length 16G /swapfile
                 ; chmod 0600 /swapfile
                 ; mkswap /swapfile
                 ;(swap-devices (list (swap-space (target "/swapfile"))))
                 #|
                 (packages
                   (append (list nss-certs ; tls certs from mozilla, required for https to work
                                 curl ; helpful for occasional debugging
                                 )
                           %base-packages))
                 |#
                 (services
                  (append (list (service dhcp-client-service-type)
                                (service openssh-service-type
                                         (openssh-configuration
                                          (openssh openssh-sans-x)
                                          (permit-root-login `prohibit-password)
                                          (password-authentication? #f)
                                          (authorized-keys
                                           `(("root" ,ssh-public-key)
                                             ))))
                                (service wireguard-service-type
                                  (wireguard-configuration
                                    (peers
                                      (list
                                        (wireguard-peer
                                          (name "smart-laptop")
                                          (public-key wireguard-public-key)
                                          (allowed-ips '("10.0.0.4/32")))))))
                                ; make acpi shutdown signal work
                                (service elogind-service-type))
                          (modify-services
                            %base-services
                            (sysctl-service-type config =>
                                    (sysctl-configuration
                                      (settings
                                        (append '(("net.ipv4.ip_forward" . "1"))
                                                %default-sysctl-settings))))
                          ;; The server must trust the Guix packages you build. If you add the signing-key
                          ;; manually it will be overridden on next `guix deploy` giving
                          ;; "error: unauthorized public key". This automatically adds the signing-key.
                          (guix-service-type config =>
                                             (guix-configuration
                                              (inherit config)
                                              (authorized-keys
                                               (append (list (local-file "/etc/guix/signing-key.pub"))
                                                       %default-authorized-guix-keys)))))))))
