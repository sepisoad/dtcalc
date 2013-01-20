(declare (unit date_switches))

;;; accepted date format:
;;; dd/mm/yyy => 14/5/1987
;;; dd.mm.yyy => 14.5.1987
;;; dd\mm\yyy => 14\5\1987
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

;;; handle date input
(define date_switch_handler
  (lambda (arguments)
    (let 
	((result #t)
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
				      (set! result #f)))))
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
	 (if (or (eq? char #\,)
		 (eq? char #\\)
		 (eq? char #\/)
		 (eq? char #\-)
		 (eq? char #\.))
	     (set! date_section (+ date_section 1))
	     (begin
	       (if (and (>= (char->integer char) 48)
			(<= (char->integer char) 57))
		   (begin
		     (cond
		      ((= date_section 0) ; day section
		       (append-to-list! day_str char))
		      ((= date_section 1) ; month section
		       (append-to-list! month_str char))
		      ((= date_section 2) ; year section
		       (append-to-list! year_str char))
		      (else (set! result #f)))) ;;; more than 3 parts
		   (set! result #f))))) ;;; if char is not a number
       date_char_list)
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
	  (is_leap_year #f))
      (if (or (< year 1000)
	      (> year 3005)
	      (< month 1)
	      (> month 12))
	  (set! result #f))
      (if (eq? result #t)
	  (begin
	    (if (or (and (eq? (remainder year 4) 0)
			 (not (eq? (remainder year 100) 0)))
		    (eq? (remainder year 400) 0))
		(set! is_leap_year #t)
		(set! is_leap_year #f))
	    (cond
	     ((eq? month 1) ;;; january
	      (if (or (<= day 0) (> day 31))
		  (set! result #f)))
	     ((= month 2) ;;; february*
	      (if (eq? is_leap_year #t) ;;; in leap years february is 29 days
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
    (display "today is: 14/5/1987")
    (newline)))
