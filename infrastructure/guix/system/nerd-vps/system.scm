(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu packages python)
             (gnu packages linux)
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
        ; debug stuff: python iptables)
      %base-packages))
  (services
    (append
      (list (service docker-service-type)
            ; wireguard
            (service wireguard-service-type
              (wireguard-configuration
                (addresses '((string-append wireguard-address-nerd-vps "/32")))
                (peers
                  (list wireguard-peer-cool-laptop
                        wireguard-peer-cloudtest))))
            (service prometheus-node-exporter-service-type
                     (prometheus-node-exporter-configuration
                       (web-listen-address (string-append wireguard-address-nerd-vps ":9100"))))
            ; /etc/docker must be writable by docker daemon
            (extra-special-file "/etc/docker/daemon.json"
                                ; todo substitue wg peer addr here!
                                (local-file "daemon.json")))
      ; ssh
      (make-vm-services `(("root" ,ssh-pubkey))))))
