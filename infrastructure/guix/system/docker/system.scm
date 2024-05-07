(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu services ssh)
             (gnu services docker)
             (gnu services monitoring)
             (guix gexp)
             (griffinht system))

(operating-system
  (host-name "docker")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (packages %vm-packages) ; podman
  #|
  (users
    (append
      (list
        (user-account
          (name "docker")
          (group "users")
          (supplementary-groups '("docker"))))
      %base-user-accounts))
  |#
  (services
    (append
      (list (service docker-service-type))
      ; ssh
      (make-vm-services `(("root" ,%vm-ssh-admin-pubkey)))))) ;("docker" ,ssh-pubkey))))))
