(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules bootloaders ssh)

; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(operating-system
 (host-name "envy-laptop")
 (timezone "Etc/UTC")
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              ; use targets
              (targets "/boot/efi")
              ;(terminal-outputs '(console))
              ))
 (file-systems (cons (file-system
                      (mount-point "/")
                      ;(device "/dev/sda1")
                      (device (file-system-label "my-root"))
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
          %base-services)))
