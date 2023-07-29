;; todo is there a more terse way to write this? like ;(use-package-modules bootloaders ssh)
(define-module (system)
               ;#:use-module (gnu system)
               ;#:use-module (gnu bootloader)
               ;#:use-module (gnu bootloader grub)
               ;#:use-module (gnu system file-systems)
               #:use-module (gnu)
               #:use-module (gnu services networking)
               #:use-module (gnu services ssh)
               #:use-module (gnu packages bootloaders)
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
                              (bootloader grub-efi-bootloader)
                              ; use targets
                              (targets "/boot/efi")
                              ;(terminal-outputs '(console))
                              ))
                 ; not specifying this causes
                 ; guix deploy: error: failed to deploy envy-laptop: missing root file system
                 (file-systems (cons (file-system
                                       (mount-point "/")
                                       (device "/dev/sda1")
                                       (type "ext4"))
                                     %base-file-systems))
                 (services
                  (append (list (service dhcp-client-service-type)
                                (service openssh-service-type
                                         (openssh-configuration
                                          (openssh openssh-sans-x)
                                          (permit-root-login #t)
                                          (password-authentication? #f)
                                          (use-pam? #f)
                                          (authorized-keys
                                           `(("root" ,(local-file "id_ed25519.pub")))))))
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
                    ; also do full upgradfe??
                    ;(service unattended-upgrade-service-type)
