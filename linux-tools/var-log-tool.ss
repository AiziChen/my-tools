#!/usr/bin/scheme --script

(let ([args (command-line)])
  (cond
    [(null? (cdr args))
      (printf "Usage: ~a show-all-logs || delete-all-logs~n" (car args))]
    [(equal? (cadr args) "show-all-logs")
      (system "find /var/log -type f")]
    [(equal? (cadr args) "delete-all-logs")
      (system "find /var/log -type f -delete")
      (display "DELETE ALL DONE")
      (newline)]
    [else
      (printf "Usage: ~a show-all-logs || delete-all-logs~n" (car args))]))
