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
  (host-name "nerd-vps")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  ; https://issues.guix.gnu.org/34255
  ; note the swap file must be manually created
  ; fallocate --length 16G /swapfile
  ; chmod 0600 /swapfile
  ; mkswap /swapfile
  (swap-devices (list (swap-space (target "/swappy"))))
  (packages
    (append
      (list
        nss-certs)
      %base-packages))
  (services
    (append
      (list (service docker-service-type)
            ; wireguard
            (service wireguard-service-type
              (wireguard-configuration
                (addresses '("10.0.0.3/32"))
                (peers
                  (list (wireguard-peer
                          (name "cool-laptop")
                          (public-key "5V21izdEyjthdeALvOrADIq1B2fvqX9I9RC4Ow37XnA=")
                          (allowed-ips '("10.0.0.9/32")))
                        #|
                        (wireguard-peer
                          (name "cloudtest")
                          ; todo
                          (public-key "aV21izdEyjthdeALvOrADIq1B2fvqX9I9RC4Ow37XnA=")
                          ; todo
                          (allowed-ips '("10.0.0.4/32")))|#))))
            (service prometheus-node-exporter-service-type
                     (prometheus-node-exporter-configuration
                       (web-listen-address "127.0.0.1:9100")))
            ; /etc/docker must be writable by docker daemon
            (extra-special-file "/etc/docker/daemon.json"
                                (local-file "daemon.json")))
      ; ssh
      (make-vm-services `(("root" ,ssh-pubkey))))))
