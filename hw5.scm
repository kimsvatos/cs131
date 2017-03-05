; hw 5: scheme

; (null-ld? obj)
; Return #t if obj is an empty listdiff, #f otherwise.
;(define (null-ld? obj) 
;	(if (or (null? obj) (not (pair? obj))) #f 
;		(eq? (car obj) (cdr obj))))

(define (null-ld? obj)
	(and (not (null? obj)) (pair? obj) (eq? (car obj) (cdr obj))))

;(listdiff? obj)
; Return #t if obj is a listdiff, #f otherwise.
(define (listdiff? obj) 
	(if (null-ld? obj) #t 
		;else
		(
			if (or (not (pair? obj)) (null? obj) (not (pair? (car obj)))) #f
			;inner else
			(
				(listdiff? (cons (cdr (car obj)) (cdr obj)))
				)
			)
	)
)
		



;(cons-ld obj listdiff)
;Return a listdiff whose first element is obj
; and whose remaining elements are listdiff. (Unlike cons,
; the last argument cannot be an arbitrary object; it must be a listdiff.)

;(car-ld listdiff)
;Return the first element of listdiff. It is an error if listdiff has 
;no elements. ("It is an error" means the implementation 
;	can do anything it likes when this happens, and we won't test this case when grading.)


;cdr-ld listdiff)
;Return a listdiff containing all but the first element of 
;listdiff. It is an error if listdiff has no elements.


;(listdiff obj …)
; Return a newly allocated listdiff of its arguments.

; length-ld listdiff)
; Return the length of listdiff.

; (append-ld listdiff …)
;Return a listdiff consisting of the elements of the first listdiff followed 
;by the elements of the other listdiffs. The resulting listdiff is 
;always newly allocated, except that it shares structure with the last argument. 
;(Unlike append, the last argument cannot be an arbitrary object; it must be a listdiff.)


;(assq-ld obj alistdiff)
;alistdiff must be a listdiff whose members are all pairs. Find the first pair 
;in alistdiff whose car field is eq? to obj, and return that pair; if there is no 
;such pair, return #f.



;(list->listdiff list)
;Return a listdiff that represents the same elements as list.


;(listdiff->list listdiff)
;Return a list that represents the same elements as listdiff.


;(expr-returning listdiff)
;Return a Scheme expression that, when evaluated, will return a 
;copy of listdiff, that is, a listdiff that has the same top-level 
;data structure as listdiff. Your implementation can assume that the 
;argument listdiff contains only booleans, characters, numbers, and symbols.




(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)
;(define d6 (listdiff ils d1 37))
;(define d7 (append-ld d1 d2 d6))
;(define e1 (expr-returning d1))





