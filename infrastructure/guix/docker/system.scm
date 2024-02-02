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
  (packages
    (append
      (list
        nss-certs)
        ;podman)
      %base-packages))
  (services
    (append
      (list (service dhcp-client-service-type)
            (service docker-service-type)
            ; /etc/docker must be writable by docker daemon
            (extra-special-file "/etc/docker/daemon.json"
                                (local-file "daemon.json"))
            #|(simple-service 'bruh etc-service-type
                            (list `("docker/daemon.json" ,(local-file "daemon.json"))))|#)
      %vm-services)))
