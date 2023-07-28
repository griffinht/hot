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
                 ;(file-systems (cons (file-system
                 ;                      (mount-point "/")
                 ;                      (device "/dev/vda1")
                 ;                      (type "ext4"))
                 ;                    %base-file-systems))
                 (file-systems %base-file-systems)
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
                          %base-services))))
