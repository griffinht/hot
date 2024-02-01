(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu services networking)
             (gnu services ssh)
             (gnu services docker)
             (guix gexp)
             (griffinht system))

(operating-system
  (host-name "docker")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  #|
  (packages
    (append
      (list
        nss-certs
        podman)
      %base-packages))
  |#
  (services
    (append
      (list (service dhcp-client-service-type)
            (service docker-service-type))
      %vm-services)))
