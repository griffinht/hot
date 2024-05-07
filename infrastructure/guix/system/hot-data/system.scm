(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu packages vpn)
             (gnu services ssh)
             (gnu services docker)
             (gnu services networking)
             (gnu services monitoring)
             (gnu packages linux)
             (guix gexp)
             (srfi srfi-1)
             (griffinht system))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "hot-data")
  (bootloader %vm-bootloader)
  (packages
    (append (list btrfs-progs)
            %base-packages))
  (file-systems
    (append (list
              (file-system
                 (mount-point "/mnt/btrfs_data")
                 (type "btrfs")
                 (options "compress=zstd")
                 (device (file-system-label "btrfs_data"))))
            %vm-file-systems))

                    #|
        (service samba-service-type
          (samba-configuration
            (enable-smbd? #t)
            (config-file (local-file "smb.conf"))))
        |#
  (services
    (append
      (list (service docker-service-type))
      (make-vm-services `(("root" ,ssh-pubkey))))))
