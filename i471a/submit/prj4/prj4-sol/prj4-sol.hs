import Data.List
import Debug.Trace
import Data.Maybe(fromMaybe)

-- Problem 1
quadraticRoots :: Floating t => t -> t -> t -> (t, t)
quadraticRoots a b c = (root1, root2) where
  d = (b^2 - 4 * a * c)
  root1 = (-b / (2*a)) + sqrt d / (2*a)
  root2 = (-b / (2*a)) - sqrt d / (2*a)
             
-- Problem 2
iterateFunction :: (a -> a) -> a -> [a]
iterateFunction f z = z : iterateFunction f (f z)

-- Problem 3
multiples n = map (n*) (iterateFunction (\x-> x+1) 0)

-- Problem 4
hailstones :: Integral a => a -> [a]
hailstones n = iterateFunction (\x-> if x `mod` 2 == 0 then x `div` 2 else 3*x + 1) n
  
-- Problem 5
elemHelper :: Eq a => a -> [a] -> Int
elemHelper n = fromMaybe (-1) . elemIndex n
hailstonesLen :: Integral a => a  -> Int
hailstonesLen n = (elemHelper 1 (hailstones n)) + 1

-- Problem 6
occurrences s c = elemIndices c s

data Tree t = Leaf t
  | Tree (Tree t) t (Tree t)

-- Problem 7
foldTree :: (t1 -> t -> t1 -> t1) -> (t -> t1) -> Tree t -> t1
foldTree treeFn leafFn (Leaf n) = leafFn n
foldTree treeFn leafFn (Tree l t r) = treeFn (foldTree treeFn leafFn l) t (foldTree treeFn leafFn r)

-- Problem 8
flattenTree :: Tree a -> [a]
flattenTree (Leaf n) = [n]
flattenTree (Tree l t r) = flattenTree l ++ [t] ++ flattenTree r 

-- Problem 9
catenateTreeLists :: Tree [a] -> [a]
catenateTreeLists tree = foldl (++) [] (flattenTree tree)
