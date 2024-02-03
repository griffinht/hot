(use-modules (gnu services version-control)
             (gnu services web)
             (gnu services samba)
             (griffinht system))

(operating-system
  (host-name "guix")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
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
      %vm-services)))
