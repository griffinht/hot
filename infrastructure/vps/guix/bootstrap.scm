(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules bootloaders ssh)


(operating-system
 (host-name "my-vps")
 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)))
 (file-systems %base-file-systems)
 (services
  (append (list (service dhcp-client-service-type)
                (service openssh-service-type
                         (openssh-configuration
                          (openssh openssh-sans-x)
                          ;; allow root login but not with a password
                          (permit-root-login `prohibit-password)
                          (authorized-keys
                           ;; authorize our public ssh key with the root user
                           `(("root" ,(local-file "id_ed25519.pub")))))))
          %base-services)))
