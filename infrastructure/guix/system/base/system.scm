(use-modules (griffinht system)
             (guix gexp))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "base")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (services (make-vm-services `(("root" ,ssh-pubkey)))))
