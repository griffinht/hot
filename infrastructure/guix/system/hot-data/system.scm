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
  (host-name "hot-data")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (services
    (append
      (list (service docker-service-type))
      (make-vm-services `(("root" ,ssh-pubkey))))))
