(declare (unit common_switches))

(use srfi-37) ; command line argument parser

(define help 
  (option
		'(#\h "help") #f #f
		(lambda _
			(display "Usage: secho [OPTION] ARG ...")
			(newline)
			(display "-h  --help  show this text")  
			(exit)
		)
	)
)

(define version
	(option
		'(#\v "version") #f #f
		(lambda _
			(display "version 0.0.1")
			(exit)
		)
	)
)

(define wrong_argument
	(lambda (error_number)
		(display "the switch is not defined!")
		(newline)
		(display "please use -h or --help to learn more")
		(exit)
	)
)
