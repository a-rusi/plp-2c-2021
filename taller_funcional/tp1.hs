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
  (Rose i hijos1) == (Rose j hijos2) = i == j && length (List.permutations hijos1 `List.intersect` List.permutations hijos2) == length (List.permutations hijos1)


foldRose:: (a -> [(Char, b)] -> b) -> RTE a -> b
foldRose f (Rose raiz hijos) = f raiz (map (\(clave, rose) -> (clave ,foldRose f rose)) hijos)

mapRTE :: (a -> b) -> RTE a -> RTE b
mapRTE f = foldRose (\x rec -> Rose (f x) rec)

nodos :: RTE a -> [a]
nodos = foldRose (\x rec -> (x : (concat $ snd $ unzip rec)))

etiquetas :: RTE a -> [Char]
etiquetas = foldRose (\x rec -> ((fst $ unzip rec) ++ (concat $ snd $ unzip rec)))

altura :: RTE a -> Int
altura = foldRose (\x rec -> if rec == [] then 1 else 1 + (maximum $ snd $ unzip rec))

ramas :: RTE a -> [String]
ramas = foldRose (\x rec -> if rec == [] then [[]] else concatMap (\ y -> map ((fst y) :) (snd y)) rec)

--implementacion de subrose utilizando recursion estructural
subRose2 (Rose raiz hijos) 0 = Rose raiz []
subRose2 (Rose raiz hijos) poda = Rose raiz (map (\(x, y) -> (x, subRose y (poda-1))) hijos)

--implementacion incompleta de subrose (no funciona)
subRose unRose poda = (foldRose (\x rec -> if poda <= 0 
    then (const $ Rose x [])
    else (aux x rec)) unRose) poda

aux :: Num t => a -> [(Char, t -> RTE a)] -> t -> RTE a
aux = (\x rec poda -> Rose x (map (\(i,j) -> (i, (j (poda-1)))) rec) )

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
otroRose = Rose 2 [('z',Rose 42 [('y',Rose 41 [])]),('x',Rose 40 [])]

arbol1 = Rose 1 [('a', Rose 1 [])]
arbol2 = Rose 1 [('a', Rose 1 []), ('z', Rose 32 [])]

unRoseConRepetidos = Rose 1 [('a', Rose 2 []), ('a', Rose 2 []), ('b', Rose 2 [])]
unRoseSinRepetidos = Rose 1 [('a', Rose 2 []), ('b', Rose 2 []), ('b', Rose 2 [])]

arbolOrden1 = Rose 1 [('a', Rose 42 []), ('b', Rose 3 []), ('c', Rose 2 [])]
arbolOrden2 = Rose 1 [('b', Rose 3 []), ('c', Rose 2 []), ('a', Rose 42 [])]

arbolOrden1ConHijos = Rose 1 [('a', Rose 42 [('a', Rose 200 [])]), ('b', Rose 3 []), ('c', Rose 2 [])]
arbolOrden2ConHijos = Rose 1 [('b', Rose 3 []),('a', Rose 42 [('a', Rose 200 [])]),  ('c', Rose 2 [])]


arbolConAltura3 = Rose 1 [('b', Rose 3 []),('a', Rose 42 [('a', Rose 200 [])]),  ('c', Rose 2 [('z', Rose 99 [])])]
arbolConAltura4 = Rose 1 [('b', Rose 3 []),('a', Rose 42 [('a', Rose 200 [('y', Rose 1 [])])]),  ('c', Rose 2 [('z', Rose 99 [])])]

arbolMismoValoresDistintasClaves1 = Rose 1 [('a', Rose 2 []), ('a', Rose 2 []), ('b', Rose 2 [])]
arbolMismoValoresDistintasClaves2 = Rose 1 [('d', Rose 2 []), ('e', Rose 2 []), ('g', Rose 2 [])]

mismoArbolDistintasRaices1 = Rose 42 [('a', Rose 2 []), ('a', Rose 2 []), ('b', Rose 2 [])]
mismoArbolDistintasRaices2 = Rose 2021 [('a', Rose 2 []), ('a', Rose 2 []), ('b', Rose 2 [])]


testsEj1 = test [
  (Rose 1 [] == Rose 1 []) ~=? True,
  (Rose 1 [] == Rose 2 []) ~=? False,
  (unRose == Rose 1 []) ~=? False,
  (unRose == otroRose) ~=? False,
  (unRose == unRose) ~=? True,
  not (arbol1 == arbol2 || arbol2 == arbol1) ~=? True,   --igualdad es simetrica
  not (unRoseConRepetidos == unRoseSinRepetidos) ~=? True,   --igualdad toma en cuenta repetidos
  (arbolOrden1 == arbolOrden2) ~=? True, --igualdad toma los contenidos del arbol, sin importar su orden
  (arbolOrden1ConHijos == arbolOrden2ConHijos) ~=? True,
  (arbolMismoValoresDistintasClaves1 == arbolMismoValoresDistintasClaves2) ~=? False, --a la igualdad le importan los valores de las claves
  (mismoArbolDistintasRaices1 == mismoArbolDistintasRaices2) ~=? False
  ]

testsEj2 = test [
  foldRose (\x rec -> Rose x rec) unRose ~=? unRose,
  foldRose (\x rec -> if rec == [] then 0 else 1 + (maximum $ snd $ unzip rec)) unRose ~=? 2,
  mapRTE (\x -> x + 1 ) (Rose 1 []) ~=? Rose 2 []
  ]

testsEj3 = test [
  nodos (Rose 1 []) ~=? [1],
  nodos (unRose) ~=? [1,2,4,3],
  altura (Rose 1 []) ~=? 1,
  altura (unRose) ~=? 3,
  altura arbolOrden1ConHijos ~=? 3,
  altura arbolConAltura3 ~=? 3,
  altura arbolConAltura4 ~=? 4
  ]

testsEj4 = test [
  etiquetas (Rose 1 []) ~=? [],
  etiquetas (unRose) ~=? ['a','b','c']
  ]

testsEj5 = test [
  ramas (Rose 1 []) ~=? [""],
  ramas (unRose) ~=? ["ac", "b"]
  ]

testsEj6 = test [
  subRose2 (Rose 1 []) 1 ~=? Rose 1 [],
  subRose2 unRose 1 ~=? (Rose 1 [('a',Rose 2 []),('b',Rose 3 [])])
  ]