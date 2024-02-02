(use-modules (gnu services version-control)
             (gnu services web)
             (griffinht system))

(operating-system
  (host-name "guix")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  #|
  (packages
    (append
      (list
        nss-certs)
        ;podman)
      %base-packages))|#
  (services (append (list (service nginx-service-type))
                    %vm-services)))
