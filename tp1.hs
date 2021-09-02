import Test.HUnit
import qualified Data.List as List



data RTE a = Rose a [(Char,RTE a)]


instance Show a => Show (RTE a) where
  show (Rose i xs) = "Rose " ++ show i ++ " " ++ show xs


--------------Resolver--------------

instance Eq a => Eq (RTE a) where
  (Rose i []) == (Rose j []) = i == j
  (Rose i _) == (Rose j []) = False
  (Rose i []) == (Rose j _) = False
  (Rose i xs) == (Rose j ys) = i == j && compareListsRec xs ys

compareListsRec :: (Foldable t, Eq a) => [a] -> t a -> Bool
compareListsRec [] ys = True
compareListsRec (x:xs) ys = any (\val -> val == x) ys && compareListsRec xs ys

foldRose:: (a -> [(Char, b)] -> b) -> RTE a -> b
foldRose f (Rose raiz hijos) = f raiz (map (\(clave, rose) -> (clave ,foldRose f rose)) hijos)

sumaTupla [] = 0
sumaTupla (x:xs) = snd x + sumaTupla xs

mapRTE :: (a -> b) -> RTE a -> RTE b
mapRTE f = foldRose (\x rec -> Rose (f x) rec)

nodos :: RTE a -> [a]
nodos = foldRose (\x rec -> (x : (concat $ snd $ unzip rec)))

-- (1 : [(clave, [2:4]), []])


etiquetas :: RTE a -> [Char]
etiquetas = undefined


altura :: RTE a -> Int
altura = foldRose (\x rec -> if rec == [] then 0 else 1 + (maximum $ snd $ unzip rec))

ramas :: RTE a -> [String]
ramas = undefined


subRose :: RTE a -> Int -> RTE a
subRose = undefined


tests :: IO Counts
tests = do runTestTT allTests

allTests = test [
  "ejercicio1" ~: testsEj1,
  "ejercicio2" ~: testsEj2,
  "ejercicio3" ~: testsEj3,
  "ejercicio4" ~: testsEj4,
  "ejercicio5" ~: testsEj5,
  "ejercicio6" ~: testsEj6
  ]

unRose = Rose 1 [('a',Rose 2 [('c',Rose 4 [])]),('b',Rose 3 [])]

testsEj1 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

testsEj2 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

testsEj3 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

testsEj4 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

testsEj5 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

testsEj6 = test [
  2 ~=? 1+1,
  4 ~=? 2*2
  ]

  --}