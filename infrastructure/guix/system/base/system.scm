(use-modules (griffinht system)
             (guix gexp))

(operating-system
  (host-name "base")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (services (make-vm-services `(("root" ,%vm-ssh-admin-pubkey)))))
