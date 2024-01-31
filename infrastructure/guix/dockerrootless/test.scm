(use-modules (ice-9 rdelim)
             (ice-9 popen))

(define (pipe*-to-string command . args)
  (let ((output-port (apply open-pipe* (append (list "OPEN_WRITE" command) args))))
    (let loop ((lines '()))
      (let ((line (read-line output-port)))
        (if (eof-object? line)
            (begin
              (close-pipe output-port)
              (apply string-append (reverse lines)))
            (loop (cons (string-append line "\n") lines)))))))

(let ((output (pipe*-to-string "ls" "-l")))
  (display output))
