(declare (uses utilities))      ; utility functions
(declare (uses common_switches)); common switches like help, version, ...
(declare (uses date_switches))  ; date specific switches
(declare (uses time_switches)) 	; time specific switches

(use srfi-37) 			; command-line-arguments

(define app_version "1.0.0")
(define app_license "GPL3")
(define app_copyright "Sepehr Aryani - 2013")
(define app_author_name "Sepehr Aryani")
(define app_author_email "sepehr.aryani@gmail.com")
(define app_author_twitter "@sepisoad")

(define date_calc_mode #f)
(define time_calc_mode #f)
(define cmd_args (list 'null))

(if (null? (command-line-arguments))
    (help_switch_handler))

(for-each
 (lambda (item)
   (append-to-list! cmd_args item))
 (command-line-arguments))

(for-each
 (lambda(item)
   (cond
    ((or (equal? item "--date")  (equal? item "-d"))
     (if (eq? (date_switch_handler (cdr cmd_args)) #t)
	  (exit)
	  (fail_to_parse_handler)))
    ((or (equal? item "--time")  (equal? item "-t"))
     (if (eq? (time_switch_handler (cdr cmd_args)) #t)
	 (exit)
	 (fail_to_parse_handler)))
    ((or (equal? item "--help")  (equal? item "-h"))
     (help_switch_handler))
    ((or (equal? item "--version") (equal? item "-v"))
     (version_switch_handler app_version))
    ((or (equal? item "--info") (equal? item "-i"))
     (info_switch_handler 
      app_author_name
      app_author_email
      app_author_twitter
      app_license
      app_version))
    (else
     (wrong_switch_handler item))))
 cmd_args)
