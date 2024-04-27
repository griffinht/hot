(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu services ssh)
             (gnu services docker)
             (gnu services monitoring)
             (gnu services vpn)
             (guix gexp)
             (griffinht system))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "griffinht")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (packages
    (append
      (list
        nss-certs)
      %base-packages))
  (services
    (append
      (list (service docker-service-type)
            (service wireguard-service-type
              (wireguard-configuration
                (addresses '((string-append wireguard-address-griffinht "/32")))
                (peers
                  (list wireguard-peer-cool-laptop
                        )))))
                        ;wireguard-peer-hot))))
      (make-vm-services `(("root" ,ssh-pubkey))))))
