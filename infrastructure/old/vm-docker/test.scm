(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (system)
             (guix gexp))

(make-system
  (plain-file "sshpubkey.pub" (getenv "test_ssh_pubkey"))
  (getenv "test_wg_pubkey")) ; wireguard pubkey
