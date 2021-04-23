-- Exercise 1

-- function which adds two numbers
add n1 n2 = n1 + n2

-- same, but define without using args
plus = (+)

-- function which concats two lists
conc ls1 ls2 = ls1 ++ ls2

-- partially apply above functions:

add10 = add 10
plus5 = plus 5
concHello = conc "hello"

-- Exercise 2
first (v, _) = v
second (_, v) = v
fst3 (v, _, _) = v
snd3 (_, v, _) = v
sumFirst2 lst = sum (take 2 lst)
fnFirst2 ls f1 f2 = if (length ls) == 2 then f1 (take 2 ls) else f2 (take 2 ls)
-- Exercise 3

cartesianProduct ls1 ls2 =
  [ (x, y) | x <- ls1, y <- ls2 ]

cartesianProductIf ls1 ls2 predicate =
  [ (x, y) | x <- ls1, y <- ls2, predicate x y ]

oddEvenPairs n =  [(x, y) | x <- [1..n], odd x, y <- [1..n], even y]

