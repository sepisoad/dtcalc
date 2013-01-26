(declare (unit common_switches))

;;; print application help
(define help_switch_handler
  (lambda ()
    (display "Usage: dtcalc [SWITCH] [[OPTION]...]")
    (newline)
    (display "Switch  Long Version                Description")
    (newline)
    (display " -h      --help                      displays all the switches")
    (newline)
    (display " -d      --date                      date specific switch")
    (newline)
    (display " -t      --time                      time specific switch")
    (newline)
    (display " -i      --info                      displays application's information")
    (newline)
    (display " -v      --version                   displays application's version")
    (newline)
    (newline)
    (display "how to calculate date:")
    (newline)
    (display "dtcalc -d dd.mm.yyyy +/add num")
    (newline)
    (display "using -d/--date without any options will show current date")
    (newline)
    (display "dtcalc -d 14.5.1987 + 10 => 24.5.1987")
    (newline)
    (display "dtcalc -d 14.5.1987 - 1120 => 19.4.1984")
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

(define fail_to_parse_handler
  (lambda ()
    (display "please use -h or --help to learn how to use 'dtcalc'")
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
