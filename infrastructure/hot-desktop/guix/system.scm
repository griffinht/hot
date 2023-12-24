;; todo is there a more terse way to write this? like ;(use-package-modules bootloaders ssh)
(define-module (system)
               ;#:use-module (gnu system)
               ;#:use-module (gnu bootloader)
               ;#:use-module (gnu bootloader grub)
               ;#:use-module (gnu system file-systems)
               #:use-module (gnu)
               #:use-module (gnu services networking) ; dhcp or static ip configuration
               #:use-module (gnu services ssh) ; ssh daemon
               #:use-module (gnu services virtualization) ; ssh daemon
               ;#:use-module (gnu packages bootloaders) ; grub
               ;#:use-module (gnu packages curl) ; curl
               ;#:use-module (gnu packages certs) ; nss-certs
               #:use-module (gnu packages ssh))
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(define-public %system
               (operating-system
                 (host-name "hot-desktop")
                 ;todo remove timezone not necessary? defaults are fine?
                 (timezone "Etc/UTC")
                 ; legaciy bios instead of uefi - hot-desktop doesn't support uefi
                 (bootloader (bootloader-configuration (bootloader grub-bootloader)))
                 ; todo btrfs
                 (file-systems %base-file-systems)
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
                                           `(("root" ,(local-file "id_ed25519.pub"))
                                             ;("libvirt" ,(local-file "id_ed25519.pub"))
                                             ))))
                                (service libvirt-service-type
                                         (libvirt-configuration
                                           ;(unix-sock-group "libvirt")
                                           ))
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
                          ))
                 )
               )
