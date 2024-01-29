(define-module (system)
               #:use-module (gnu)
               #:use-module (gnu services networking) ; dhcp or static ip configuration
               #:use-module (gnu services ssh) ; ssh daemon
               #:use-module (gnu services vpn) ; wireguard
               #:use-module (gnu services virtualization) ; ssh daemon
               ;#:use-module (gnu packages certs) ; nss-certs
               #:use-module (gnu packages ssh)
               #:use-module (gnu packages admin))
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
(define-public %system
               (operating-system
                 (host-name "hot-desktop")
                 ;todo remove timezone not necessary? defaults are fine?
                 (timezone "Etc/UTC")
                 ; legaciy bios instead of uefi - hot-desktop doesn't support uefi
                 (bootloader (bootloader-configuration (bootloader grub-bootloader)))
                 (file-systems (cons*
                                 (file-system
                                   (mount-point "/")
                                   (type "ext4")
                                   (device (file-system-label "Guix_image")))
                                 (file-system
                                   (mount-point "/mnt/btrfs_data")
                                   (type "btrfs")
                                   (options "compress=zstd")
                                   (device (file-system-label "btrfs_data")))
                                 %base-file-systems))
                 ; https://issues.guix.gnu.org/34255
                 ; note the swap file must be manually created
                 ; fallocate --length 16G /swapfile
                 ; chmod 0600 /swapfile
                 ; mkswap /swapfile
                 (swap-devices (list (swap-space (target "/swapfile"))))
                 (packages
                   (append (list netcat) ; allows libvirt to spice/vnc/idk what its called
                           %base-packages))
                 #|
                 (packages
                   (append (list nss-certs ; tls certs from mozilla, required for https to work
                                 curl ; helpful for occasional debugging
                                 )
                           %base-packages))
                 |#
                 (users
                   (append
                     (list
                       (user-account
                         (name "libvirt")
                         (group "users")
                         (supplementary-groups
                           (list "kvm")))) ; "libvirt"
                     %base-user-accounts))
                 (services
                  (append (list ;(service dhcp-client-service-type)
                                ;(service wpa-supplicant-service-type)
                                ; todo elogind desktop-services
                                (service network-manager-service-type
                                         (network-manager-configuration
                                           (shepherd-requirement '()))) ; no need for wpa_supplicant or iwd
                                (service openssh-service-type
                                         (openssh-configuration
                                          (openssh openssh-sans-x)
                                          (permit-root-login `prohibit-password)
                                          (password-authentication? #f)
                                          (authorized-keys
                                           `(("root" ,(local-file "id_ed25519.pub")) ; https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html
                                             ("libvirt" ,(local-file "id_ed25519.pub"))
                                             ))))
                                (service libvirt-service-type
                                         (libvirt-configuration
                                           ;(unix-sock-group "libvirt")
                                           ))
                                (service virtlog-service-type) ; required for libvirt to work
                                (service wireguard-service-type
                                         (wireguard-configuration
                                           (addresses '("10.0.0.2/32"))
                                           (peers
                                             (list
                                               (wireguard-peer
                                                 (name "cool-laptop")
                                                 (public-key "5V21izdEyjthdeALvOrADIq1B2fvqX9I9RC4Ow37XnA=")
                                                 (allowed-ips '("10.0.0.9/32")))))))
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
