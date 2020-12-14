#!/usr/bin/scheme --script
(let ([args (command-line)])
  (cond
   [(null? (cdr args))
    (printf "Usage: ~a [port]~n" (car args))]
   [else
      (let ([port (system (string-append "netstat -nlp | grep :"
                                         (cadr args)
                                         "| awk '{print $7}'"))])
        (display port)
	(newline))]))
