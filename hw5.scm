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
(define (cons-ld obj listdiff)
	(if (listdiff? listdiff) 
		(cons (cons obj (car listdiff)) (cdr listdiff)) (error "cons-ld error"))
)


;(car-ld listdiff)
;Return the first element of listdiff. It is an error if listdiff has 
;no elements. ("It is an error" means the implementation 
;	can do anything it likes when this happens, and we won't test this case when grading.)
(define (car-ld listdiff)
	(if (not (listdiff? listdiff)) (error "car-ld error") 
		;else starts below
		(if (null-ld? listdiff) (error "car-ld error") (car (car listdiff)))
	)
)

;cdr-ld listdiff)
;Return a listdiff containing all but the first element of 
;listdiff. It is an error if listdiff has no elements.
(define (cdr-ld listdiff)
	if(or (not (listdiff? listdiff)) (null-ld? listdiff))
		(error "cdr-ld error")
		(cons (cdr(car listdiff)) (cdr listdiff))

)

;(listdiff obj …)
; Return a newly allocated listdiff of its arguments.
(define (listdiff obj . argList)
	(cons (cons obj argList) `()))



; length-ld listdiff)
; Return the length of listdiff.
(define (length-ld listdiff)
	(if(not (listdiff? listdiff)) (error "length-ld error") 
		; else
		((define (counter listdiff num) 
			(if (not (null-ld? listdiff)) 
				;  then
				(counter (cdr-ld listdiff) (+ 1 num))
				;else
				num
				)
		    )
		(counter listdiff 0)
		)
		)
)

; (append-ld listdiff …)
;Return a listdiff consisting of the elements of the first listdiff followed 
;by the elements of the other listdiffs. The resulting listdiff is 
;always newly allocated, except that it shares structure with the last argument. 
;(Unlike append, the last argument cannot be an arbitrary object; it must be a listdiff.)
(define (append-ld listdiff . argList)
	(if (null? argList) listdiff
		;else
		(apply append-ld 
		(cons (append (take (car listdiff) (length-ld listdiff)) (car (car argList)))
			(cdr (car args))) (cdr argList))
		)
)


;(assq-ld obj alistdiff)
;alistdiff must be a listdiff whose members are all pairs. Find the first pair 
;in alistdiff whose car field is eq? to obj, and return that pair; if there is no 
;such pair, return #f.
( define (assq-ld obj alistdiff)
	(if (null-ld? alistdiff) 
		(if (and (pair? (car alistdiff)) (eq? obj (car (car (car alistdiff))))) 
			(car (car alistdiff))
			;else
			#f	

	) ;else
		#f
)


;(list->listdiff list)
;Return a listdiff that represents the same elements as list.
(define (list->listdiff list)
	(if (not (list? list)) 
		(error "list->listdiff error")
		;else
		(apply listdiff (car list) (cdr list))
)
)

;(listdiff->list listdiff)
;Return a list that represents the same elements as listdiff.
(define (listdiff->list listdiff)
	(if (not (listdiff? listdiff)) 
		(error "listdiff->list error")
		(take (car listdiff) (length-ld listdiff))
)
)

;(expr-returning listdiff)
;Return a Scheme expression that, when evaluated, will return a 
;copy of listdiff, that is, a listdiff that has the same top-level 
;data structure as listdiff. Your implementation can assume that the 
;argument listdiff contains only booleans, characters, numbers, and symbols.
(define (expr-returning listdiff)
	(if (not (listdiff? listdiff))
		(error "expr-returning listdiff error")
		;else
		`(cons ',(take (car listdiff) (length-ld listdiff)) '())


		)
)


(define ils (append '(a e i o u) 'y))
(define d1 (cons ils (cdr (cdr ils))))
(define d2 (cons ils ils))
(define d3 (cons ils (append '(a e i o u) 'y)))
(define d4 (cons '() ils))
(define d5 0)
(define d6 (listdiff ils d1 37))
(define d7 (append-ld d1 d2 d6))
(define e1 (expr-returning d1))
(define kv1 (cons d1 'a))
(define kv2 (cons d2 'b))
(define kv3 (cons d3 'c))
(define kv4 (cons d1 'd))
(define d8 (listdiff kv1 kv2 kv3 kv4))
(eq? (assq-ld d1 d8) kv1)
(eq? (assq-ld d2 d8) kv2)
(eq? (assq-ld d1 d8) kv4)
(eq? (car-ld d6) ils)
(eqv? (car-ld (cdr-ld (cdr-ld d6))) 37)
(equal? (listdiff->list d6) (list ils d1 37))
(eq? (list-tail (car d6) 3) (cdr d6))
(listdiff->list (eval e1))
(equal? (listdiff->list (eval e1))
		        (listdiff->list d1))



