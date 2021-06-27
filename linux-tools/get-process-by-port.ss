#!/usr/bin/env -S scheme --script

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
      (when (= status 0)
        (printf "THE PROCESS OF THE PORT `~a` DOESN'T EXIST.~n" port)))]))
