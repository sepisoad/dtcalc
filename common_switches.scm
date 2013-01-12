(declare (unit common_switches))

;;; print application help
(define help_switch_handler
  (lambda ()
    (display "help me")
    (newline)
    (exit)))

;;; print application version
(define version_switch_handler
  (lambda (app_version)
    (display "version: ")
    (display app_version)
    (newline)
    (exit)))

(define info_switch_handler
  (lambda (author_name 
	   author_email 
	   author_twitter
	   app_license
	   app_version)    
    (display "author: ")
    (display author_name)
    (newline)
    
    (display "email: ")
    (display author_email)
    (newline)

    (display "twitter: ")
    (display author_twitter)
    (newline)

    (display "license: ")
    (display app_license)
    (newline)
    
    (display "version: ")
    (display app_version)
    (newline)
    (exit)))

(define wrong_switch_handler
  (lambda (switch)
    (display "\"")
    (display switch)
    (display "\" switch is not recognized")
    (newline)
    (display "please use -h or --help to learn how to use 'dtcalc'")
    (newline)
    (exit)))
