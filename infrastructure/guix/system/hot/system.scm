(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu packages vpn)
             (gnu services ssh)
             (gnu services docker)
             (gnu services networking)
             (gnu services monitoring)
             (guix gexp)
             (srfi srfi-1)
             (griffinht system))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "hot")
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
            ; todo actually use this feature lol
            ; i might just accomplish this with docker...
            (service network-manager-service-type ; network manager can automatically connect to wireguard
                     (network-manager-configuration
                       (shepherd-requirement '())))) ; no need for wpa-supplicant
    (remove (lambda (service)
              (eq? (service-kind service)
                   dhcp-client-service-type))
     (make-vm-services `(("root" ,ssh-pubkey)))))))
