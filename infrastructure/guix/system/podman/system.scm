(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
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
        podman)
      %vm-packages))
  (services %vm-services))
