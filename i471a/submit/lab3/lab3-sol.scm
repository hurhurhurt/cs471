
(define (quadratic-roots a b c)
  (let ((determinant (- (* b b) (* 4 a c))))
	(let ((a2 (+ a a)))
	  (if (zero? determinant)
	      (list (/ (- b) a2))
	      (let ((root (my-sqrt determinant)))
		(list (/ (- root b) a2)
		      (/ (- (- root) b) a2)))))))

(define my-sqrt (lambda (n (guess 1.0))
		  (if (> (/ (abs (- (* guess guess) n)) n) (/ 1 1000))
		      (my-sqrt n (/ (+ guess (/ n guess)) 2))
		      guess))
    )

(define (greater-than ls (num 0))
  (if (empty? ls)
      '()
      (append (if (> (car ls) num) '(#t) '(#f)) (greater-than (cdr ls) num))
      )
  )

(define (get-greater-than lst num)
  (filter (lambda (x) (and (number? x) (> x num)))
	  lst))

(define (less-than ls (num 0))
  (if (empty? ls)
      '()
      (append (if (< (car ls) num) '(#t) '(#f)) (less-than (cdr ls) num))
      )
  )

(define (get-less-than lst num)
  (filter (lambda (x) (and (number? x) (< x num)))
	            lst))
