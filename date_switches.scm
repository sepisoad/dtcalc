(declare (unit date_switches))

(require-extension srfi-19-date) ;;; scheme date library

;;; accepted date format:
;;; dd/mm/yyy => 14/5/1987
;;; dd.mm.yyy => 14.5.1987
;;; dd-mm-yyy => 14-5-1987
;;; dd,mm,yyy => 14,5,1987

;;; source_date operator operand_value => target_date
(define source_year 0);;; source year
(define source_month 0);;; source month
(define source_day 0);;; source day
(define target_year 0);;; target year
(define target_month 0);;; target month
(define target_day 0);;; target day
(define operator "+");;; operator ( +/add, -/sub )
(define operand_value 0);;; operand value (days)
(define separator_char ",")

;;; handle date input
(define date_switch_handler
  (lambda (arguments)
    (let ((result #t)
	  (num_of_args (length arguments)))
      (cond 
       ((= num_of_args 0) (print_today))       
       ((= num_of_args 1) (set! result #f))
       ((= num_of_args 2) (set! result #f))
       ((= num_of_args 3) (if (eq? (parse_source_date (car arguments)) #f)
			      (set! result #f)
			      (if (eq? (parse_operator (car (cdr arguments))) #f)
				  (set! result #f)
				  (if (eq? (parse_operand (car (cdr (cdr arguments)))) #f)
				      (set! result #f)
				      (begin
					(calculate_date source_year
							source_month
							source_day
							operator
							operand_value)
					(display source_day)
					(display separator_char)
					(display source_month)
					(display separator_char)
					(display source_year)
					(display " ")
					(display operator)
					(display " ")
					(display operand_value)
					(display " => ")
					(display target_day)
					(display separator_char)
					(display target_month)
					(display separator_char)
					(display target_year)
					(newline))))))
       (else (set! result #f)))
      (if (eq? result #t)
	  #t
	  #f))))

(define parse_source_date
  (lambda (date)
    (let ((result #t)
	  (date_char_list (string->list date))
	  (day_str (list 'null))
	  (month_str (list 'null))
	  (year_str (list 'null))
	  (date_section 0))
      (for-each
       (lambda (char)
	 (cond ((or (eq? char #\,)
		    (eq? char #\\) ;;; this one has issue
		    (eq? char #\/)
		    (eq? char #\-)
		    (eq? char #\.))
		(set! date_section (+ date_section 1)))
	       ((and (>= (char->integer char) 48)
		     (<= (char->integer char) 57))
		(begin
		  (cond
		   ((= date_section 0) ; day section
		    (append-to-list! day_str char))
		   ((= date_section 1) ; month section
		    (append-to-list! month_str char))
		   ((= date_section 2) ; year section
		    (append-to-list! year_str char))
		   (else (set! result #f))))) ;;; more than 3 parts
	       (else (set! result #f))))
       date_char_list)
      (if (or (equal? day_str '(null))
	      (equal? month_str '(null))
	      (equal? year_str '(null)))
	  (begin
	    (display "entered date format is incorrect")
	    (newline)
	    (set! result #f)))
      (if (eq? result #t)
	  (let ((day_num (string->number (list->string day_str)))
		(month_num (string->number (list->string month_str)))
		(year_num (string->number (list->string year_str))))
	    (if (eq? (verify_date day_num month_num year_num) #f)
		(set! result #f)
		(begin
		  (set! source_year year_num)
		  (set! source_month month_num)
		  (set! source_day day_num)))))
      (if (eq? result #t)
	  #t
	  #f))))

;;;
(define verify_date
  (lambda (day month year)
    (let ((result #t)
	  (leap_year #f))
      (if (or (< year 1000)
	      (> year 3005)
	      (< month 1)
	      (> month 12))
	  (set! result #f))
      (if (eq? result #t)
	  (begin
	    (if (is_leap_year year)
		(set! leap_year #t)
		(set! leap_year #f))
	    (cond
	     ((= month 1) ;;; january
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 2) ;;; february*
					;(display "fuck")
	      (if (eq? leap_year #t) ;;; in leap years february is 29 days
		  (if (or (<= day 0) (> day 29))
		      (set! result #f))
		  (if (or (<= day 0) (> day 28))
		      (set! result #f))))
	     ((= month 3) ;;; march
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 4) ;;; april
	      (if (or (<= day 0) (> day 30))
		  (set! result #f)))
	     ((= month 5) ;;; may
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 6) ;;; june
	      (if (or (<= day 0) (> day 30))
		  (set! result #f)))
	     ((= month 7) ;;; july
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 8) ;;; august
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 9) ;;; september
	      (if (or (<= day 0) (> day 30))
		  (set! result #f)))
	     ((= month 10) ;;; october
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 11) ;;; november
	      (if (or (<= day 0) (> day 30))
		  (set! result #f)))
	     ((= month 12) ;;; december
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     (else (set! result #f)))))
      (if (eq? result #t)
	  #t
	  #f))))

;;;
(define is_leap_year
  (lambda (year)
    (if (or (and (eq? (remainder year 4) 0)
		 (not (eq? (remainder year 100) 0)))
	    (eq? (remainder year 400) 0))
	#t
	#f)))

;;;
(define parse_operator
  (lambda (op)
    (let ((result #t))
      (if (or (equal? op "+")
	      (equal? op "add")
	      (equal? op "-")
	      (equal? op "sub"))
	  (set! result #t)
	  (set! result #f))
      (if (eq? result #t)
	  (set! operator op))
      (if (eq? result #t)
	  #t
	  #f))))

;;;
(define parse_operand
  (lambda (operand)
    (let ((result #t)
	  (val 0))
      (if (number? (string->number operand))
	  (set! val (string->number operand))
	  (set! result #f))
      (if (or (< val -99999)
	      (> val 99999))
	  (set! result #f))
      (if (eq? result #t)
	  (set! operand_value val))
      (if (eq? result #t)
	  #t
	  #f))))

;;;
(define print_today
  (lambda ()
    (let ((today (current-date)))
	  (display "today is: ")
	  (display (date-day today))
	  (display separator_char)
	  (display (date-month today))
	  (display separator_char)
	  (display (date-year today))
	  (newline))))

;;; returns the number of months
(define days_in_month
  (lambda (year month)
    (let ((leap_year #f)
	  (result 0))
      (if (is_leap_year year)
	  (set! leap_year #t)
	  (set! leap_year #f))
      (cond
       ((= month 1) 31)  ;;; january
       ((= month 2) (if (eq? leap_year #t) 29 28)) ;;; february
       ((= month 3) 31)  ;;; march
       ((= month 4) 30)  ;;; april
       ((= month 5) 31)  ;;; may
       ((= month 6) 30)  ;;; june
       ((= month 7) 31)  ;;; july
       ((= month 8) 31)  ;;; august
       ((= month 9) 30)  ;;; september
       ((= month 10) 31) ;;; october
       ((= month 11) 30) ;;; november
       ((= month 12) 31) ;;; december
       (else #f)))))
  

(define calculate_date
  (lambda (year month day operation operand)
    (let ((month_len 1))
      (if (eq? operand 0)	  
	  (begin
	    (set! target_year year)
	    (set! target_month month)
	    (set! target_day day))
	  (begin
	    (set! month_len (days_in_month year month)) ;;; set month length
	    (cond 
	     ((or (equal? operation "add") (equal? operation "+"))
	      (begin
		(if (<= operand (- month_len day))
		    (begin
		      (set! day (+ day operand))
		      (calculate_date year month day operation 0))
		    (begin
		      (set! operand (- operand (- month_len day)))
		      (set! operand (- operand 1))
		      (set! day 1)
		      (if (eq? month 12)
			  (begin
			    (set! month 1)
			    (set! year (+ year 1)))
			  (set! month (+ month 1)))
		      (calculate_date year month day operation operand)))))
	     ((or (equal? operation "sub") (equal? operation "-"))
	      (begin
		(if (and (< operand day))
		    (begin
		      (set! day (- day operand))
		      (calculate_date year month day operation 0))
		    (begin
		      (set! operand (- operand day))
		      ;(set! operand (- operand 1))
		      ;(set! day ())
		      (if (eq? month 1)
			  (begin
			    (set! month 12)
			    (set! year (- year 1)))
			  (set! month (- month 1)))
		      (set! day (days_in_month year month))
		      (calculate_date year month day operation operand)))))))))))
