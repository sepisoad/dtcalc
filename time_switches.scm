(declare (unit time_switches))

(require-extension srfi-19-date) ;;; scheme date/time library

;;; accepted time format:
;;; hh.mm.ss => 14/5/1987
;;; hh:mm:ss => 14.5.1987

;;; source_time operator operand_value => target_time
(define source_hour 0);;; source hour
(define source_minute 0);;; source minute
(define source_second 0);;; source second
(define target_houre 0);;; target hour
(define target_minute 0);;; target minute
(define target_second 0);;; target second
(define operator "+");;; operator ( +/add, -/sub )
(define operand_value 0);;; operand value (seconds)
(define time_separator_char ":")

;;; handle date input
(define time_switch_handler
  (lambda (arguments)
    (let ((result #t)
	  (num_of_args (length arguments)))
      (cond 
       ((= num_of_args 0) (print_current_time))       
       ((= num_of_args 1) (set! result #f))
       ((= num_of_args 2) (set! result #f))
       ((= num_of_args 3) (if (eq? (parse_source_time (car arguments)) #f)
			      (set! result #f)
			      (if (eq? (parse_operator (car (cdr arguments))) #f)
				  (set! result #f)
				  (if (eq? (parse_operand (car (cdr (cdr arguments)))) #f)
				      (set! result #f)
				      (begin
					(calculate_time source_hour
							source_minute
							source_second
							operator
							operand_value)
					(display source_hour)
					(display time_separator_char)
					(display source_minute)
					(display time_separator_char)
					(display source_second)
					(display " ")
					(display operator)
					(display " ")
					(display operand_value)
					(display " => ")
					(display target_hour)
					(display time_separator_char)
					(display target_minute)
					(display time_separator_char)
					(display target_second)
					(newline))))))
       (else (set! result #f)))
      (if (eq? result #t)
	  #t
	  #f))))

(define parse_source_time
  (lambda (time)
    (let ((result #t)
	  (time_char_list (string->list time))
	  (hour_str (list 'null))
	  (minute_str (list 'null))
	  (second_str (list 'null))
	  (time_section 0))
      (for-each
       (lambda (char)
	 (cond ((or (eq? char #\.)
		    (eq? char #\:)) ;;; this one has issue
		(set! time_section (+ time_section 1)))
	       ((and (>= (char->integer char) 48)
		     (<= (char->integer char) 57))
		(begin
		  (cond
		   ((= time_section 0) ; hour section
		    (append-to-list! hour_str char))
		   ((= time_section 1) ; minute section
		    (append-to-list! minute_str char))
		   ((= time_section 2) ; secind section
		    (append-to-list! second_str char))
		   (else (set! result #f))))) ;;; more than 3 parts
	       (else (set! result #f))))
       time_char_list)
      (if (or (equal? hour_str '(null))
	      (equal? minute_str '(null))
	      (equal? second_str '(null)))
	  (begin
	    (display "entered time format is incorrect")
	    (newline)
	    (set! result #f)))
      (if (eq? result #t)
	  (let ((hour_num (string->number (list->string hour_str)))
		(minute_num (string->number (list->string minute_str)))
		(second_num (string->number (list->string second_str))))
	    (if (eq? (verify_time hour_num minute_num second_num) #f)
		(set! result #f)
		(begin
		  (set! source_hour hour_num)
		  (set! source_minute minute_num)
		  (set! source_second second_num)))))
      (if (eq? result #t)
	  #t
	  #f))))

;;;
(define verify_time
  (lambda (hour minute second)
    (let ((result #t))
      (if (or (or (<= hour 0) (> hour 24))
	      (or (< minute 0) (> minute 59))
	      (or (< second 0) (> hour 59)))
	  #f
	  #t))))

;;;
;(define parse_operator
;  (lambda (op)
;    (let ((result #t))
;      (if (or (equal? op "+")
;	      (equal? op "add")
;	      (equal? op "-")
;	      (equal? op "sub"))
;	  (set! result #t)
;	  (set! result #f))
;      (if (eq? result #t)
;	  (set! operator op))
;      (if (eq? result #t)
;	  #t
;	  #f))))

;;;
;(define parse_operand
;  (lambda (operand)
;    (let ((result #t)
;	  (val 0))
;      (if (number? (string->number operand))
;	  (set! val (string->number operand))
;	  (set! result #f))
;      (if (or (< val -99999)
;	      (> val 99999))
;	  (set! result #f))
;      (if (eq? result #t)
;	  (set! operand_value val))
;      (if (eq? result #t)
;	  #t
;	  #f))))

;;;
(define print_current_time
  (lambda ()
    (let ((today (current-date)))
	  (display "the time is: ")
	  (display (date-hour today))
	  (display time_separator_char)
	  (display (date-minute today))
	  (display time_separator_char)
	  (display (date-second today))
	  (newline))))

(define calculate_time
  (lambda (hour minute second operation operand)
    (if (eq? operand 0)
	(begin
	  (set! target_hour hour)
	  (set! target_minute minute)
	  (set! target_second second))
	(begin
	  (cond 
	   ((or (equal? operation "add") (equal? operation "+"))
	    (begin
	      (if (<= operand (- 60 second))
		  (begin
		    (set! second (+ second operand))
		    (calculate_time hour minute second operation 0))
		  (begin
		    (set! operand (- operand (- 60 second)))
		    (set! second 0)
		    (if (eq? minute 59)
			(begin
			  (set! minute 0)
			  (set! hour (+ hour 1))
			  (if (> hour 24)
			      (set! hour 1)))
			(set! minute (+ minute 1)))
		    (calculate_time hour minute second operation operand)))))
	   ((or (equal? operation "sub") (equal? operation "-"))
	    (begin
	      (if (<= operand second)
		  (begin
		    (set! second (- second operand))
		    (calculate_time hour minute second operation 0))
		  (begin
		    (set! operand (- operand second))
		    (set! second 60)
		    (if (eq? minute 0)
			(begin
			  (set! minute 59)
			  (set! hour (- hour 1))
			  (if (< hour 1)
			      (set! hour 24)))
			(set! minute (- minute 1)))
		    (calculate_time hour minute second operation operand))))))))))
