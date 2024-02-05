(use-modules (gnu packages admin)
             (gnu packages virtualization)
             (gnu packages ssh)
             (gnu services base)
             (gnu services admin)
             (gnu services vpn)
             (gnu services ssh)
             (gnu services networking)
             (gnu services desktop)
             (gnu system setuid)
             (guix gexp)
             (griffinht system))

(operating-system
  (host-name "hypervisor")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  ; https://issues.guix.gnu.org/34255
  ; note the swap file must be manually created
  ; fallocate --length 16G /swapfile
  ; chmod 0600 /swapfile
  ; mkswap /swapfile
  ;(swap-devices (list (swap-space (target "/swapfile"))))
  (packages
    (append (list netcat ; allows libvirt to spice/vnc/idk what its called
                  libvirt ; normally installed by the libvirtd service
                  qemu) ; normally installed by the libvirtd service
            %base-packages))

  (users
    (append (list (user-account
                    (name "libvirt")
                    (group "users")
                    (supplementary-groups
                      (list "kvm")))) ; allows kvm virtualization for speedy vms
            %base-user-accounts))
  (services
    (append (list ; network manager! makes bridge networks easier
                  (service network-manager-service-type
                           (network-manager-configuration
                             (shepherd-requirement '()))) ; no need for wpa_supplicant or iwd, this isn't a laptop with wifi
                   ; make the physical power button work
                   (service elogind-service-type)
                   ; sshd
                   (service openssh-service-type
                            (openssh-configuration
                              (openssh openssh-sans-x)
                              (permit-root-login `prohibit-password)
                              (password-authentication? #f)
                              (authorized-keys
                                `(("root" ,(local-file "../cool-laptop.pub"))
                                  ("libvirt" ,(local-file "../cool-laptop.pub"))))))
                    ; libvirt
                    ;(service libvirt-service-type)
                    ;(service virtlog-service-type) ; required for libvirt to work
                    ; qemu-bridge-helper
                    (extra-special-file "/usr/libexec/qemu-bridge-helper" "/run/setuid-programs/qemu-bridge-helper")
                    (extra-special-file "/etc/qemu/bridge.conf" (plain-file "" "allow br0\n"))
                    ; wireguard
                    (service wireguard-service-type
                      (wireguard-configuration
                        (addresses '("10.0.0.2/32"))
                        (peers
                          (list (wireguard-peer
                                  (name "cool-laptop")
                                  (public-key "5V21izdEyjthdeALvOrADIq1B2fvqX9I9RC4Ow37XnA=")
                                  (allowed-ips '("10.0.0.9/32"))))))))
            (modify-services %base-services
                             ;; The server must trust the Guix packages you build. If you add the signing-key
                             ;; manually it will be overridden on next `guix deploy` giving
                             ;; "error: unauthorized public key". This automatically adds the signing-key.
                             (guix-service-type config =>
                                             (guix-configuration
                                              (inherit config)
                                              (authorized-keys
                                               (append (list (local-file "/etc/guix/signing-key.pub"))
                                                       %default-authorized-guix-keys)))))
                          ))
  ; qemu-bridge-helper
  (setuid-programs
    (append (list (setuid-program
                    (program (file-append qemu "/libexec/qemu-bridge-helper"))))
            %setuid-programs)))
