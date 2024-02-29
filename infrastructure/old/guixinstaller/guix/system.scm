(define-module (system)
               #:use-module (gnu)
               #:use-module (gnu services networking) ; dhcp or static ip configuration
               #:use-module (gnu services ssh) ; ssh daemon
               #:use-module (gnu packages bootloaders) ; grub
               #:use-module (gnu packages ssh))
(define-public %system
               (operating-system
                 (host-name "my-custom-guix-installer")
                 ;todo remove timezone not necessary? defaults are fine?
                 (timezone "Etc/UTC")
                 (bootloader (bootloader-configuration
                               ; https://guix.gnu.org/manual/en/html_node/Building-the-Installation-Image.html
                              (bootloader grub-bootloader)
                              ;(targets '("/boot/efi"))
                              ;(terminal-outputs '(console))
                              ))
                 (file-systems %base-file-systems)
                 (services
                  (append (list (service dhcp-client-service-type)
                                ; unattended upgrades - why not i suppose todo hopefully this doesn't break anything
                                ; https://guix.gnu.org/manual/en/html_node/Unattended-Upgrades.html
                                ; todo disable
                                ;(service unattended-upgrade-service-type)
                                (service openssh-service-type
                                         (openssh-configuration
                                          (openssh openssh-sans-x)
                                          (permit-root-login `prohibit-password)
                                          (password-authentication? #f)
                                          (authorized-keys
                                           `(("root" ,(local-file "id_ed25519.pub"))
                                             ))))
                                )
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
