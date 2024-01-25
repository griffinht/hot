(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (system)
             (guix gexp))

(make-system
  (local-file "id_ed25519.pub")
  "5V21izdEyjthdeALvOrADIq1B2fvqX9I9RC4Ow37XnA=")
