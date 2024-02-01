(use-modules (gnu bootloader)
             (gnu bootloader grub)
             (gnu system file-systems)
             (gnu packages ssh)
             (gnu services base)
             (gnu services networking)
             (gnu services desktop)
             (gnu services ssh)
             (guix gexp))

(operating-system
  (host-name "base")
  (bootloader (bootloader-configuration (bootloader grub-bootloader)))
  (file-systems %base-file-systems)
  (services
    (append
      (list (service dhcp-client-service-type)
            ; make acpi shutdown work
            todo use vm services idk todo
            (service elogind-service-type)
            (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (permit-root-login `prohibit-password)
                      (password-authentication? #f)
                      (authorized-keys
                       `(("root" ,(local-file "../id_ed25519.pub")))))))
      %base-services)))
