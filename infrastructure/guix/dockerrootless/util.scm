(use-modules (ice-9 rdelim)
             (ice-9 popen))

; todo send standard error to /dev/null
(define (ssh-keyscan host port type)
  "runs ssh-keyscan on the given host with port for given type.
   returns the string, or an empty string on error"
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
