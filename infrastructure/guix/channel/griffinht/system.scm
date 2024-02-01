(define-module (griffinht system)
               #:use-module (gnu bootloader)
               #:use-module (gnu bootloader grub)
               #:use-module (gnu system file-systems)
               #:use-module (gnu services)
               #:use-module (gnu services base)
               #:use-module (gnu services desktop)
               #:use-module (guix gexp))

(define-public %vm-bootloader
  (bootloader-configuration (bootloader grub-bootloader)))

(define-public %vm-file-systems
  (append
    (list
      (file-system
      (mount-point "/")
      (type "ext4")
      (device (file-system-label "Guix_image"))))
    %base-file-systems))

(define-public %vm-services
  (append
    (list
      ; make acpi shutdown work
      (service elogind-service-type))
    (modify-services
      %base-services
      ; https://stumbles.id.au/getting-started-with-guix-deploy.html
      ;; The server must trust the Guix packages you build. If you add the signing-key
      ;; manually it will be overridden on next `guix deploy` giving
      ;; "error: unauthorized public key". This automatically adds the signing-key.
      (guix-service-type
        config =>
        (guix-configuration
        (inherit config)
        (authorized-keys
          (append
            (list (local-file "/etc/guix/signing-key.pub"))
            %default-authorized-guix-keys)))))))
