(declare (uses common_switches))   ; common switches like help, version, ...
(declare (uses date_switches)) 		; date specific switches
(declare (uses time_switches)) 		; time specific switches

(use srfi-37) 						; command line argument parser

(for-each 
	(lambda (item) 
		(print* item #\space)
	)
	(reverse
  		(args-fold 
  			(command-line-arguments) 
  			(list help version date)
			(lambda (o err_num item vals)
				(wrong_argument err_num)
			)
			cons '() 
		) 
	) 
)
