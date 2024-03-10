(use-modules (griffinht system))

(operating-system
  (host-name "base")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (services %vm-services))
