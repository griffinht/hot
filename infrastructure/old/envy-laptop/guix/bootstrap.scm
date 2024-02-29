(add-to-load-path (string-append (dirname (current-filename)) "/"))
(use-modules (system))

; guix expects this file to evaluate to an (operating-system ...) declaration
%system
