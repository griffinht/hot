(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu services networking)
             (gnu services ssh)
             (guix gexp)
             (griffinht system))

(operating-system
  (host-name "podman")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (packages
    (append
      (list
        nss-certs
        podman)
      %base-packages))
  (services
    (append
      (list (service dhcp-client-service-type)
            (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (permit-root-login `prohibit-password)
                      (password-authentication? #f)
                      (authorized-keys
                       `(("root" ,(local-file "../id_ed25519.pub")))))))
      %vm-services)))
