;;-*- mode: scheme; -*-
;; :set filetype=scheme

;;Return the list resulting by multiplying each element of `list` by `x`.
(define (mul-list lst x)
  (if (null? lst)
      '()
      (cons (* x (car lst)) (mul-list (cdr lst) x))))

;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the top-level contained lists.
(define (sum-lengths lst)
  (define (len lst)
    (if (empty? lst)
	0
	(+ 1 (len (cdr lst)))))
  (if (empty? lst)
      0
      (+ (len (car lst)) (sum-lengths (cdr lst)))))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  The computation should reflect the traditional
;;representation of the polynomial.
;;(define (poly-eval coeffs x)

(define (poly-eval coeffs x)
  (define (poly-eval-helper-tail factor coeffs n accum)
    (cond
     [(null? coeffs) accum]
     [else (poly-eval-helper-tail factor (cdr coeffs) (- n 1) (+ accum (* (car coeffs) (expt factor n))))]))
  (poly-eval-helper-tail x coeffs (sub1 (length coeffs)) 0))
  
;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x using Horner's method.
(define (poly-eval-horner coeffs x)
  

;;Return count of occurrences equal? to x in exp
(define (count-occurrences exp x)
  (if (not (pair? exp))
      (if (equal? exp x)
	  1
	  0
	  )
      (if (equal? (car exp) x)
	  (+ 1 (count-occurrences (cdr exp) x))
	  (+ (count-occurrences (car exp) x) (count-occurrences (cdr exp) x))))) 

;;Return result of evaluating arith expression over Scheme numbers
;;with fully parenthesized prefix binary operators 'add, 'sub, 'mul
;;and 'div.
(define (arith-eval exp)
  '())  ;TODO

;;Given a proper-list list of proper-lists, return sum of lengths of
;;all the contained lists.  Must be tail-recursive.
(define (sum-lengths-tr lst)
  (if (null? lst)
      0
      (if (list? (car lst))
	  (+ (sum-lengths (car lst)) (sum-lengths (cdr lst)))
	  (+ (car lst) (sum-lengths (cdr lst))))))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  Must be tail-recursive.
(define (poly-eval-horner-tr coeffs x)
  (cond
   [(equal? 0 (length coeffs)) 0]
   [(equal? 1 (length coeffs)) (car coeffs)]
   [else (poly-eval-horner-tr (append (list (+ (* (car coeffs) x) (car (cdr coeffs)))) (cdr (cdr coeffs))) x)]))
 
;;Return the list resulting by multiplying each element of `list` by `x`.
;;Cannot use recursion, can use one or more of `map`, `foldl`, or `foldr`.
(define (mul-list-2 lst x)
  (map (lambda (y) (* x y)) lst))

;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the contained lists.  Cannot use recursion, can use
;;one or more of `map`, `foldl`, or `foldr`.
(define (sum-lengths-2 lst)
  (foldl (lambda (lst x) (+ (length lst) x)) 0 lst))
