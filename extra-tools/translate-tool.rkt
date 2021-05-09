#lang racket

(require net/url
         json)


(define CONTEXT_URL "https://translate.yandex.net/api/v1/tr.json/translate?srv=android&text=")
(define LANG_EXT "&lang=")


(define input-file-name "input.txt")
(define output-file-name "output.txt")
(define lang "zh")

(let ([args (current-command-line-arguments)])
  (cond
    [(= (vector-length args) 3)
     (set! input-file-name (vector-ref args 0))
     (set! output-file-name (vector-ref args 1))
     (set! lang (vector-ref args 2))
     (do-translate)]
    [else (displayln "Usage: translate-tool [input-file] [output-file] [lang(eg. zh)]")]))


; delete the destination file
(when (file-exists? output-file-name)
  (delete-file output-file-name))


(define can-be-translate?
  (lambda (s)
    (not (or (string-contains? s ":")
             (number? (string->number s))
             (equal? "\r" s)
             (equal? "\n" s)
             (equal? "\r\n" s)
             (string-contains? s (string #\uFEFF))))))


(define read-to-empty-line
  (lambda (p)
    (let* ([line (read-line p)])
      (cond
        [(eof-object? line) ""]
        [else
         (let ([tline (string-trim line)])
           (cond
             [(not (can-be-translate? line)) tline]
             [else (string-append tline (read-to-empty-line p))]))]))))


(define append-text-to-file
  (lambda (fname text)
    (display-to-file text fname #:mode 'text #:exists 'append)))


(define url->jsonexp
  (lambda (url)
    (let ([p (get-pure-port url)])
      (read-json p))))
      
(define (do-translate)
  (call-with-input-file input-file-name
    (lambda (fip)
      (let loop ([line (read-to-empty-line fip)])
        (cond
          [(eof-object? line)]
          [else
           (cond
             [(can-be-translate? line)
              (let* ([lang-ext (string-append LANG_EXT lang)]
                     [surl (string-append CONTEXT_URL line lang-ext)]
                     [url (string->url surl)]
                     [jexp (url->jsonexp url)])
                (when (= 200 (hash-ref jexp 'code))
                  (let ([translated-text (car (hash-ref jexp 'text))])
                    (displayln (string-append line " ---> " translated-text))
                    (append-text-to-file output-file-name (string-append translated-text "\n\n")))))]
             [else (append-text-to-file output-file-name (string-append line "\n"))])])
        (loop (read-to-empty-line fip))))))