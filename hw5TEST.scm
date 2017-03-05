; Return if obj is an empty listdiff or not
; Make sure that object is valid by testing if it is a pair
; and then just make sure the two elements of the pair listdiff
; are the same, which thus means the listdiff is null.
(define (null-ld? obj)
	(and (not (null? obj)) (pair? obj) (eq? (car obj) (cdr obj))))

; Return if obj is a listdiff or not
; Go through all the elements through the listdiff unti
; we hit an empty list diff, so that we know that obj is a listdiff
; otherwise, if we don't have a valid pair for the obj or the car
; of the obj then we know that it is not a valid listdiff.
(define (listdiff? obj) 
	(if (not (null-ld? obj)) 
		;then
		(
			if (or (not (pair? obj)) (null? obj) (not (pair? (car obj)))) #f
			;inner else
			
				(listdiff? (cons (cdr (car obj)) (cdr obj)))
				
			)
		;else
		#t
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
	(if (or (not (listdiff? listdiff)) (null-ld? listdiff))
		(error "cdr-ld error")
		;else
		(cons (cdr(car listdiff)) (cdr listdiff))


)
)


;(listdiff obj …)
; Return a newly allocated listdiff of its arguments.
(define (listdiff obj . argList)
	(cons (cons obj argList) `()))


; length-ld listdiff)
; Return the length of listdiff.
(define (length-ld listdiff)
	(define (count-ld listdiff num)
		(if (listdiff? listdiff)

			(if (not (null-ld? listdiff))
				(count-ld (cdr-ld listdiff) (+ 1 num))
				;else
				num
			)
			(error "length-ld error")

		)
	)
	(count-ld listdiff 0)

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
			(cdr (car args))) (cdr argList)
		)
		)
)

; ;(assq-ld obj alistdiff)
; ;alistdiff must be a listdiff whose members are all pairs. Find the first pair 
; ;in alistdiff whose car field is eq? to obj, and return that pair; if there is no 
; ;such pair, return #f.
( define (assq-ld obj alistdiff)
	(if (null-ld? alistdiff) 
		(if (and (pair? (car alistdiff)) (eq? obj (car (car (car alistdiff))))) 
			(car (car alistdiff))
			;else
			#f	

	) ;else
		#f
)
)

; Return a listdiff that represents the same elements as list.
; Reuse the listdiff function, unpacking the list as a set of 
; arguments.
(define (list->listdiff list)
  	(if (list? list)
		(apply listdiff (car list) (cdr list))
		(error "ERROR! -5")
	)
)

; Return a list that represents the same elements as listdiff.
; Simply take the difference of the listdiff, which implicitly
; returns a list.
(define (listdiff->list listdiff)
  	(if (listdiff? listdiff)
		(take (car listdiff) (length-ld listdiff))
		(error "ERROR! -6")
	)
)

; Return a Scheme expression that, when evaluated, will return a copy of listdiff, 
; that is, a listdiff that has the same top-level data structure as listdiff. 
; Your implementation can assume that the argument listdiff contains only 
; booleans, characters, numbers, and symbols.
; Use a quasiquote to produce the difference of lists and cons that with 
; an empty list to create a valid listdiff thus giving us a shallow copy of 
; the original listdiff.
(define (expr-returning listdiff)
  	(if (listdiff? listdiff)
		`(cons ',(take (car listdiff) (length-ld listdiff)) '())
		(error "ERROR! -7")
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

(listdiff? d1)                        
(listdiff? d2)                        
(listdiff? d3)                        
(listdiff? d4)                        
(listdiff? d5)                        
(listdiff? d6)                        
(listdiff? d7)                        

(null-ld? d1)                         
(null-ld? d2)                         
(null-ld? d3)                         
(null-ld? d6)                         

(car-ld d1)                           
;(car-ld d2)                           
;(car-ld d3)                           
(car-ld d6)                           

(length-ld d1)                        
(length-ld d2)                        
;(length-ld d3)                        
(length-ld d6)                        
(length-ld d7) 