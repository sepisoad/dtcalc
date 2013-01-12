(declare (unit utilities))

;;; this function appends an item to a list
(define append-to-list!
  (lambda (list item)
    (if (eq? (car list) 'null)
	(set-car! list item)
	(begin
	  (if (null? (cdr list))
	      (set-cdr! list (cons item '()))
	      (append-to-list! (cdr list) item))))))
