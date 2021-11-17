campeon((morgana,200,30)).
campeon((brand,230,40)).
campeon((chogat,400,50)).
campeon((amumu,380,60)).
campeon((soraka,300,10)).
campeon((nami,250,20)).
campeon((akali,200,150)).
campeon((evelyn,200,130)).
campeon((teemo,180,80)).


tipo(morgana,mago).
tipo(brand,mago).
tipo(chogat,tanque).
tipo(amumu,tanque).
tipo(soraka,soporte).
tipo(nami,soporte).
tipo(akali,asesino).
tipo(evelyn,asesino).
tipo(teemo,mago).

% desde(+X,-Y)
desde(X, X).
desde(X, Y) :- N is X+1, desde(N, Y).

% sonCampeones(+L)
sonCampeones([]).
sonCampeones([L|LS]) :- campeon(L), sonCampeones(LS).

% equipoInfinito(-E)
equipoInfinito(E) :- desde(1,Tamaño), length(E,Tamaño), sonCampeones(E).

distintosTipos(_, []).
distintosTipos((L,HP,DAÑO), [(L1,_,_)|LS]) :- tipo(L, TIPO), tipo(L1, TIPO1), TIPO \= TIPO1, distintosTipos((L,HP,DAÑO), LS).

sinTiposRepetidos([]).
sinTiposRepetidos([L|LS]) :- distintosTipos(L, LS), sinTiposRepetidos(LS).

% equipoValido(-E)
equipoValido(E) :- 
between(1,4,CantJugadores),
length(E,CantJugadores),
sonCampeones(E),
sinTiposRepetidos(E).

bajarAD([], [], _).
bajarAD([(NOMBRE, HP, AD)|E2],[(NOMBRE1, HP1, AD1)|E2F], ATAQUE) 
:- NOMBRE1 = NOMBRE, HP1 is HP,AD1 is AD - ATAQUE, bajarAD(E2, E2F, ATAQUE).

atacar(mago, (_, _, AD), E1, E2, E1F, E2F) :- bajarAD(E2, E2F, AD), E1F = E1.
%atacar(asesino, E1, E2, E1F, E2F) :-
%atacar(tanque, E1, E2, E1F, E2F) :-
%atacar(soporte, E1, E2, E1F, E2F) :-

% stepPelea(+E1, +E2, -E1F, -E2F)
%stepPelea([(NOMBRE, HP, AD)|E1], E2, E1F, E2F) :- tipo(NOMBRE, TIPO),
%  atacar(TIPO, (NOMBRE, HP, AD), E1, E2, E1F, E2F),
%  moverAtras((NOMBRE, HP, AD), E1, E1F).

% pelea(+E1, +E2, +C, -G)






% gana(?E1, +E2)





% honor(+E1, +E2, -C)









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTS

cantidadTestsEquipoInfinito(9).
testEquipoInfinito(1) :- campeon(X), equipoInfinito(E), E = [X].
testEquipoInfinito(2) :- equipoInfinito(E), E = [(teemo,180,80), (akali,200,150)].
testEquipoInfinito(3) :- equipoInfinito(E), E = [(akali,200,150), (teemo,180,80)].
testEquipoInfinito(4) :- equipoInfinito(E), E = [(morgana,200,30), (morgana,200,30)].
testEquipoInfinito(5) :- equipoInfinito(E), E = [(teemo,180,80), (morgana,200,30)].
testEquipoInfinito(6) :- equipoInfinito(E), E = [(nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20)].
testEquipoInfinito(7) :- equipoInfinito(E), E = [(nami,250,20),(akali,200,150), (evelyn,200,130), (teemo,180,80)].
testEquipoInfinito(8) :- equipoInfinito(E), E = [(akali,200,150), (nami,250,20), (evelyn,200,130), (teemo,180,80)].
testEquipoInfinito(9) :- equipoInfinito(E), E = [(teemo,180,80), (akali,200,150), (nami,250,20), (evelyn,200,130)].

cantidadTestsEquipoValido(5).
testEquipoValido(1) :- campeon(X), equipoValido(E), E = [X].
testEquipoValido(2) :- equipoValido(E), E = [(teemo,180,80), (akali,200,150)].
testEquipoValido(3) :- equipoValido(E), E = [(akali,200,150), (teemo,180,80)].
testEquipoValido(4) :- equipoValido(E), not((E = [(morgana,200,30), (morgana,200,30)])).
testEquipoValido(5) :- equipoValido(E), not((E = [(teemo,180,80), (morgana,200,30)])).

cantidadTestsStepPelea(10).
testStepPelea(1) :- stepPelea([(morgana,200,30)], [(brand,230,40)], E1, E2), E1 = [(morgana,200,30)], E2 = [(brand,230,10)].
testStepPelea(2) :- stepPelea([(morgana,200,30)], [(soraka,300,10)], E1, E2), E1 = [(morgana,200,30)], E2 = [(soraka,300,0)].
testStepPelea(3) :- stepPelea([(morgana,200,30)], [(brand,230,40), (chogat,400,50)], E1, E2), E1 = [(morgana,200,30)], E2 = [(brand,230,10), (chogat,400,20)].
testStepPelea(4) :- stepPelea([(amumu,400,50)], [(brand,230,40), (chogat,400,50)], E1, E2), E1 = [(amumu,400,50)], E2 = [(brand,180,40), (chogat,350,50)].
testStepPelea(5) :- stepPelea([(amumu,400,50)], [(brand,50,40), (chogat,400,50)], E1, E2), E1 = [(amumu,400,50)], E2 = [(chogat,350,50)].
testStepPelea(6) :- stepPelea([(amumu,400,50)], [(brand,40,40), (chogat,400,50)], E1, E2), E1 = [(amumu,400,50)], E2 = [(chogat,350,50)].
testStepPelea(7) :- stepPelea([(soraka,300,10), (morgana,200,30), (amumu,400,50)], [(brand,230,40), (chogat,400,50)], E1, E2), E1 = [(morgana,210,40), (amumu,410,60), (soraka,300,10)], E2 = [(brand,230,40), (chogat,400,50)].
testStepPelea(8) :- stepPelea([(akali,200,150)], [(brand,230,40), (chogat,400,50)], E1, E2), E1 = [(akali,200,150)], E2 = [(brand,80,40), (chogat,400,50)].
testStepPelea(9) :- stepPelea([(akali,200,150)], [(brand,160,40), (chogat,50,50)], E1, E2), E1 = [(akali,200,150)], E2 = [(brand,10,40), (chogat,50,50)].
testStepPelea(10) :- stepPelea([(akali,200,150), (brand,160,40), (chogat,50,50)], [(morgana,160,40), (amumu,50,50)], E1, E2), E1 = [(brand,160,40), (chogat,50,50), (akali,200,150)], E2 = [(morgana,10,40), (amumu,50,50)].


cantidadTestsPelea(14).
testPelea(1) :- pelea([(morgana,200,30)], [(brand,230,40)], 1, G), G = [].
testPelea(2) :- pelea([(morgana,200,30)], [(soraka,300,10)], 1, G), G = [].
testPelea(3) :- pelea([(morgana,200,30)], [(brand,230,40), (chogat,400,50)], 1, G), G = [(brand,230,10), (chogat,400,20)].
testPelea(4) :- pelea([(amumu,400,50)], [(brand,230,40), (chogat,400,50)], 1, G), G = [(brand,180,40), (chogat,350,50)].
testPelea(5) :- pelea([(amumu,400,50)], [(brand,50,40), (chogat,400,50)], 1, G), G = [].
testPelea(6) :- pelea([(amumu,400,50)], [(brand,40,40), (chogat,400,50)], 1, G), G = [].
testPelea(7) :- pelea([(soraka,300,10), (morgana,200,30), (amumu,400,50)], [(brand,230,40), (chogat,400,50)], 1, G), G = [(morgana,210,40), (amumu,410,60), (soraka,300,10)].
testPelea(8) :- pelea([(akali,200,150)], [(brand,230,40), (chogat,400,50)], 1, G), G = [(brand,80,40), (chogat,400,50)].
testPelea(9) :- pelea([(akali,200,150)], [(brand,160,40), (chogat,50,50)], 1, G), G = [(brand,10,40), (chogat,50,50)].
testPelea(10) :- pelea([(akali,200,150), (brand,160,40), (chogat,50,50)], [(morgana,160,40), (amumu,50,50)], 1, G), G = [(brand,160,40), (chogat,50,50), (akali,200,150)].
testPelea(11) :- pelea([(akali,200,130)], [(evelyn,120,130),(teemo,40,80)], 1, G), G = [].
testPelea(12) :- pelea([(akali,200,130)], [(evelyn,120,130),(teemo,40,80)], 2, G), G = [].
testPelea(13) :- pelea([(akali,200,130)], [(evelyn,120,130),(teemo,40,80)], 3, G), G = [(akali,200,50)].
testPelea(14) :- pelea([(akali,200,150)], [(brand,160,40), (chogat,50,50)], 5, G), G = [(akali,200,70)].

cantidadTestsGana(5).
testGana(1) :- not(gana([(morgana,200,30)], [(brand,230,40), (chogat,400,50)])).
testGana(2) :- gana([(brand,230,40), (chogat,400,50)], [(morgana,200,30)]).
testGana(3) :- gana([(akali,200,130)], [(evelyn,120,130),(teemo,40,80)]).
testGana(4) :- gana(E, [(akali,200,150)]), E = [(evelyn, 200, 130)].
testGana(5) :- gana(E, [(evelyn, 200, 130)]), member(E, [[(chogat, 400, 50)], [(akali, 200, 150)]]).

cantidadTestsHonor(4).
testHonor(1) :- honor([(soraka,300,10), (chogat,400,50)], [(teemo, 50, 0)], C), member(C, [soraka, chogat]).
testHonor(2) :- honor([(akali,200,150)], [(brand,160,40), (chogat,50,50)], C), C = akali.
testHonor(3) :- honor([(amumu,400,50)], [(brand,230,40), (chogat,400,50)], C), member(C, [brand, chogat]).
testHonor(4) :- honor([(evelyn, 100, 100)], [(akali, 1000, 50), (teemo, 1000, 50)], C), C = teemo.

tests(equipoInfinito) :- cantidadTestsEquipoInfinito(M), forall(between(1,M,N), testEquipoInfinito(N)).
tests(equipoValido) :- cantidadTestsEquipoValido(M), forall(between(1,M,N), testEquipoValido(N)).
tests(stepPelea) :- cantidadTestsStepPelea(M), forall(between(1,M,N), testStepPelea(N)).
tests(pelea) :- cantidadTestsPelea(M), forall(between(1,M,N), testPelea(N)).
tests(gana) :- cantidadTestsGana(M), forall(between(1,M,N), testGana(N)).
tests(honor) :- cantidadTestsHonor(M), forall(between(1,M,N), testHonor(N)).

tests(todos) :-
  tests(equipoInfinito),
  tests(equipoValido),
  tests(stepPelea),
  tests(pelea),
  tests(gana),
  tests(honor).

tests :- tests(todos).
