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

(operating-system
  (host-name "griffinht")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (packages %vm-packages)
  (services
    (append
      (list (service docker-service-type))
      (make-vm-services `(("root" ,%vm-ssh-admin-pubkey))))))
