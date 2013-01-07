(declare (unit date_switches))

(use srfi-37) ; command line argument parser
(use srfi-19) ; date/time

(define date
  (option
		'(#\d "date") #f #f
		(lambda (o1)
			(display "today is 0.0.1")
			(exit)
		)
	)
)
