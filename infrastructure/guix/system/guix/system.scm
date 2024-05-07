(use-modules (gnu services version-control)
             (gnu services samba)
             (gnu services sysctl)
             (gnu services vpn)
             (gnu services networking)
             (gnu services monitoring)
             (griffinht system))

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
  (packages %vm-packages) ; podman
  ; todo rsyslogd! monitoring!
  (services
    (append
      (list
        (service wireguard-service-type
          (wireguard-configuration
            (addresses (list (string-append wireguard-address-guix "/32")))
            (port 51821)
            (peers
              (list wireguard-peer-cool-laptop)
                      )))
        (service prometheus-node-exporter-service-type)
        (service nftables-service-type
          (nftables-configuration (ruleset (local-file "wireguard.nft"))))
        (service samba-service-type ; todo containerize? only if its easier! (it probably is idk... if this is a container host!)
          (samba-configuration
            (enable-smbd? #t)
            (config-file (local-file "smb.conf")))))
      (modify-services
        (make-vm-services `(("root" ,%vm-ssh-admin-pubkey)))
        (sysctl-service-type
          config =>
          (sysctl-configuration
            (settings
              (append '(("net.ipv4.ip_forward" . "1")) ; todo ipv6!
                      %default-sysctl-settings))))))))
; todo attach multiple nics for private nfs networking! i think that means a bridge without
