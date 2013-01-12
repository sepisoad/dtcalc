(declare (unit time_switches))

;;; handle time input
(define time_switch_handler
  (lambda (arguments)
    (for-each
     (lambda (item)
       (display item)
       (newline))
     (arguments))
    (exit)))

