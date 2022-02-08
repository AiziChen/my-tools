#!/usr/bin/env scheme-script

(import (chezscheme))

(define display-usage
  (lambda (app-name)
    (printf "Usage: ~a show-all-logs || remove-all-logs~n" app-name)))

(let ([args (command-line)])
  (cond
   [(null? (cdr args))
    (display-usage (car args))]
   [(equal? (cadr args) "show-all-logs")
    (system "find /var/log -type f")]
   [(equal? (cadr args) "remove-all-logs")
    (if (= 0 (system "find /var/log -type f -delete"))
        (display "LOGS REMOVE ALL DONE")
        (printf "LOGS REMOVE FAILED"))
    (newline)]
   [else
    (display-usage (car args))]))
