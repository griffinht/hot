;; todo is there a more terse way to write this? like ;(use-package-modules bootloaders ssh)
(define-module (system)
               ;#:use-module (gnu system)
               ;#:use-module (gnu bootloader)
               ;#:use-module (gnu bootloader grub)
               ;#:use-module (gnu system file-systems)
               #:use-module (gnu)
               #:use-module (gnu services networking) ; dhcp or static ip configuration
               #:use-module (gnu services vpn) ; wireguard
               #:use-module (gnu services ssh) ; ssh daemon
               #:use-module (gnu services admin) ; unattended upgrades
               #:use-module (gnu services desktop) ; elogind (for docker)
               #:use-module (gnu services dbus) ; dbus (for docker)
               #:use-module (gnu services docker) ; docker
               #:use-module (gnu packages bootloaders) ; grub
               #:use-module (gnu packages curl) ; curl
               #:use-module (gnu packages certs) ; nss-certs
               #:use-module (gnu packages ssh))
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
;;(define-public my-system 
; %system is used just because other variable like things use the % prefix
; i could have called this just system or my-system or %%system or whatever
(define-public %system
               (operating-system
                 (host-name "envy-laptop")
                 ;todo remove timezone not necessary? defaults are fine?
                 (timezone "Etc/UTC")
                 (bootloader (bootloader-configuration
                               ; https://guix.gnu.org/manual/en/html_node/Building-the-Installation-Image.html
                              ;(bootloader grub-efi-bootloader) ; vm
                              (bootloader grub-bootloader) ; bootable iso9066
                              ; use targets
                              ; from guix source tree gnu/system/install.scm
                              (targets '("/dev/sda")) ; bootable iso9066
                              ;todo test with vm??
                              ; also see guix gnu/system/vm.scm
                              ;(targets "/boot/efi") ; vm
                              ;(terminal-outputs '(console))
                              ))
                 ; not specifying this causes
                 ; guix deploy: error: failed to deploy envy-laptop: missing root file system
                 ;(file-systems (cons (file-system
                 ;                      (mount-point "/")
                 ;                      (device "/dev/sda1")
                 ;                      (type "ext4"))
                 ;                    %base-file-systems))
                 (swap-devices (list (swap-space
                        (target (uuid
                                 "dc7b01d4-9397-4d65-bb55-42624b99788e")))))
                 (file-systems (cons* (file-system
                                       (mount-point "/boot/efi")
                                       (device (uuid "BC0D-7922"
                                                     'fat16))
                                       (type "vfat"))
                                     (file-system
                                       (mount-point "/")
                                       ; /dev/sda4
                                       (device (uuid "30d92fd9-8068-46c6-94b8-8770bc24494d"
                                                     'ext4))
                                       (type "ext4")) %base-file-systems))
                 (users (cons (user-account
                                (name "docker-user")
                                (group "users")
                                (supplementary-groups '("docker")))
                              %base-user-accounts))
                 (packages
                   (append (list nss-certs ; tls certs from mozilla, required for https to work
                                 curl ; helpful for occasional debugging
                                 )
                           %base-packages))
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
                                          ; defaults
                                          ;(challenge-response-authentication? #f) ; not needed?
                                          ;(use-pam? #t) ; allows login for locked user accounts
                                          (authorized-keys
                                           `(("root" ,(local-file "id_ed25519.pub"))
                                             ("docker-user" ,(local-file "id_ed25519.pub"))))))
                                (service elogind-service-type) ; (for docker)
                                ; https://www.reddit.com/r/GUIX/comments/w5w15p/comment/ihbh4zs/
                                (service dbus-root-service-type) ; (for docker)
                                (service docker-service-type)
                                ; todo https://www.procustodibus.com/blog/2022/11/wireguard-jumphost/
                                (service wireguard-service-type
                                         (wireguard-configuration
                                           (addresses '("10.0.0.1/32"))
                                           (port 51820)
                                           ; todo postup postdown iptables nftable!?!?
                                           (peers
                                             (list
                                               (wireguard-peer
                                                 (name "smart-laptop")
                                                 (public-key "V//LVPk6jLy6tQWxIyqDapeP7kj2bZ84YAsmCoigdQ4=")
                                                 (allowed-ips '("10.0.0.4/32")))
                                               (wireguard-peer
                                                 (name "phone")
                                                 (public-key "wYQ3XafEpdjMIdkbjRFm4iVAF8v0sIYzLrcxgkLHTjI=")
                                                 (allowed-ips '("10.0.0.5/32")))
                                               )))))
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
