(use-modules (gnu bootloader)
             (gnu bootloader grub)
             (gnu system file-systems)
             (gnu packages ssh)
             (gnu packages certs)
             (gnu services base)
             (gnu services networking)
             (gnu services desktop)
             (gnu services ssh)
             (gnu services docker)
             (guix gexp))

(operating-system
  (host-name "dockerrootless")
  (bootloader (bootloader-configuration (bootloader grub-bootloader)))
  (file-systems
    (append
      (list
        (file-system
          (mount-point "/")
          (type "ext4")
          (device (file-system-label "Guix_image"))))
      %base-file-systems))
  (users
    (append
      (list
        (user-account
          (name "docker")
          (group "users")))))
  (services
    (append
      (list (service dhcp-client-service-type)
            ; make acpi shutdown work
            (service elogind-service-type)
            (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (permit-root-login `prohibit-password)
                      (password-authentication? #f)
                      (authorized-keys
                       `(("root" ,(local-file "../id_ed25519.pub")))))))
      (modify-services
        %base-services
        ;; The server must trust the Guix packages you build. If you add the signing-key
        ;; manually it will be overridden on next `guix deploy` giving
        ;; "error: unauthorized public key". This automatically adds the signing-key.
        (guix-service-type
          config =>
          (guix-configuration
          (inherit config)
          (authorized-keys
            (append
              (list (local-file "/etc/guix/signing-key.pub"))
              %default-authorized-guix-keys))))))))
