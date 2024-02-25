(use-modules (gnu services version-control)
             (gnu services web)
             (gnu services samba)
             (gnu services sysctl)
             (griffinht system))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "guix")
  (bootloader %vm-bootloader)
  (file-systems
    (append (list
              (file-system
                (mount-point "/mnt/btrfs_data")
                (type "tmpfs")
                (options "size=10M")
                (device "tmpfs"))
              #|
              (file-system
                 (mount-point "/mnt/btrfs_data")
                 (type "btrfs")
                 (options "compress=zstd")
                 (device (file-system-label "btrfs_data")))|#)
             %vm-file-systems))
  #|
  (packages
    (append
      (list
        nss-certs)
        ;podman)
      %base-packages))|#
  ; todo rsyslogd! monitoring!
  (services
    (append
      (list
        ;(service nginx-service-type)
        (service samba-service-type ; todo containerize?
          (samba-configuration
            (enable-smbd? #t)
            (config-file (local-file "smb.conf")))))
      (modify-services
        (make-vm-services `(("root" ,ssh-pubkey)))
        (sysctl-service-type
          config =>
          (sysctl-configuration
            (settings
              (append '(("net.ipv4.ip_forward" . "1")) ; todo ipv6!
                      %default-sysctl-settings))))))))
; todo attach multiple nics for private nfs networking! i think that means a bridge without
