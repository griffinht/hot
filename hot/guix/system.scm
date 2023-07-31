(use-modules (gnu))
(use-package-modules curl certs)
(use-service-modules web)
;; todo is there a more terse way to write this? like ;(use-package-modules bootloaders ssh)
(operating-system
  (host-name "envy-laptop")
  (file-systems %base-file-systems)
  (bootloader (bootloader-configuration
                ; todo grub-efi-bootloader?
                (bootloader grub-bootloader)))
  ;todo remove timezone not necessary? defaults are fine?
  (packages (append (list nss-certs ; tls certs from mozilla, required for https to work
                          curl) ; helpful for occasional debugging
                    %base-packages))
  (services (append (list (service nginx-service-type
                                   (nginx-configuration
                                     (server-blocks
                                       (list (nginx-server-configuration
                                               (listen '("8080"))
                                               ;(root "/srv/http/www.example.com")
                                               ))))))
                    %base-services)))
