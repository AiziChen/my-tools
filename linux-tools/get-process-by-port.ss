#!/usr/bin/env scheme-script
(import (chezscheme))

(define display-usage
  (lambda (app-name)
    (printf "Usage: ~a [port]~n" app-name)))

(let ([args (command-line)])
  (cond
   [(null? (cdr args))
    (display-usage (car args))]
   [else
    (let* ([port (cadr args)]
           [cmd (string-append
                 "netstat -nlp | grep :"
                 port
                 "| awk '{print $7}'")]
           [status (system cmd)])
      (unless (= status 0)
        (printf "error occurred.~n")))]))
