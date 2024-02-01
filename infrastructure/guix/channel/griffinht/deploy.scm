(define-module (griffinht deploy)
               #:use-module (ice-9 rdelim)
               #:use-module (ice-9 popen)
               #:use-module (gnu machine ssh))

(define (ssh-keyscan host port type)
  "runs ssh-keyscan on the given host with port for given type.
   returns the string, or an empty string on error"
  ; todo send standard error to /dev/null
  (let* ((input-port (open-pipe* OPEN_READ "ssh-keyscan" "-p" port "-t" type host))
         (line (read-line input-port)))
    (begin
      (close-pipe input-port)
      (if (eof-object? line)
        ; empty string on error
        ""
        ; [127.0.0.1]:2222 ed25519 AAAAC... -> ed25519 AAAAC...
        ; todo if ssh-keyscan can't resolve a host then this fails with an ugly error
        (substring line (+ (string-index line #\space) 1) (string-length line))))))

; full guix operating system which can be deployed with guix deploy to target which is already running guix
; https://stumbles.id.au/getting-started-with-guix-deploy.html 
; https://guix.gnu.org/manual/en/html_node/operating_002dsystem-Reference.html
(define-public (local-machine-ssh-configuration)
  (machine-ssh-configuration
    ;; this is the domain or ip address of the target machine
    (host-name "127.0.0.1")
    ;; why is system required?
    (system "x86_64-linux")
    ;; ssh public key of remote system
    ;; obtain with `ssh-keyscan -p 2222 hostname`
    (host-key (ssh-keyscan "127.0.0.1" "2222" "ed25519"))
    ;; private key of host machine to authenticate with
    ;; leave default its fine i think
    ; todo change to something idk
    ;;(identity "id_ed25519.pub")
    ;; ssh server port of remote system, default 22
    (port 2222)))
