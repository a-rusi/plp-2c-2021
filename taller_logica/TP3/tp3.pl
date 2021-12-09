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
% Es reversible E? -> No, no lo es. Si se le pasa un input invalido (como un arreglo de numeros),
% el auxiliar "desde" hara que chequee infinitamente si sonCampeones.
% En caso de ser un equipo valido de campeones, devolvera true cuando Tamaño coincida con el largo del equipo,
% pero al pedirle mas resultados desde haria que el programa se trabe.

% distintosTipos(+CAMPEON, +LISTA)
distintosTipos(_, []).
distintosTipos((L,HP,DAÑO), [(L1,_,_)|LS]) :- tipo(L, TIPO), tipo(L1, TIPO1), TIPO \= TIPO1, distintosTipos((L,HP,DAÑO), LS).

% sinTiposRepetidos(+L)
sinTiposRepetidos([]).
sinTiposRepetidos([L|LS]) :- distintosTipos(L, LS), sinTiposRepetidos(LS).

% equipoValido(-E)
equipoValido(E) :- 
between(1,4,CantJugadores),
length(E,CantJugadores),
sonCampeones(E),
sinTiposRepetidos(E).
% Es reversible E? -> De manera similar equipoInfinto, va a chequear que sea valido length, sonCampeones y ahora tambien sinTiposRepetidos.
% La principal diferencia es que no usamos el auxiliar "desde": la cantidad de chequeos que hacemos con between es finita.
% Entonces programa no se cuelga porque hace una cantidad finita de chequeos, y devuelve true cuando es valido y false cuando el input es invalido.

% bajarAD(+E, -EF, +ATAQUE)
bajarAD([], [], _).
bajarAD([(NOMBRE, HP, AD)|E2],[(NOMBRE1, HP1, AD1)|E2F], ATAQUE) 
:- NOMBRE1 = NOMBRE, HP1 is HP, AD1 is max(AD - ATAQUE,0), bajarAD(E2, E2F, ATAQUE).

% bajarHPAlPrimero(+E, -EF, +ATAQUE)
bajarHPAlPrimero([], [], _).
bajarHPAlPrimero([(NOMBRE, HP, AD)|E2],[(NOMBRE1, HP1, AD1)|E2F], ATAQUE) 
:- HP - ATAQUE > 0, NOMBRE1 = NOMBRE, AD1 is AD, HP1 is HP - ATAQUE, E2F = E2.
bajarHPAlPrimero([(_, HP, _)|E2],E2F, ATAQUE) 
:- HP - ATAQUE =< 0, E2F = E2.

% bajarHP(+E, -EF, +ATAQUE)
bajarHP([], [], _).
bajarHP([(NOMBRE, HP, AD)|E2],[(NOMBRE1,HP1,AD1)|E2F], ATAQUE) 
:- HP - ATAQUE > 0, NOMBRE1 = NOMBRE, AD1 is AD, HP1 is HP - ATAQUE, bajarHP(E2, E2F, ATAQUE).
bajarHP([(_, HP, _)|E2],E2F, ATAQUE) 
:- HP - ATAQUE =< 0, bajarHP(E2, E2F, ATAQUE).

% buffearEquipo(+E, -EF, +ATAQUE)
buffearEquipo([], [], _).
buffearEquipo([(NOMBRE, HP, AD)|E1],[(NOMBRE1, HP1, AD1)|E1F], ATAQUE) 
:- NOMBRE1 = NOMBRE, AD1 is AD + ATAQUE, HP1 is HP + ATAQUE, buffearEquipo(E1, E1F, ATAQUE).

% moverAtras(+CAMPEON, +E, -EF)
moverAtras(CAMPEON, E1, E1F) :- append(E1, [CAMPEON], E1F).

% atacar(+TIPO, +CAMPEON, +E1, +E2, -E1F, -E2F)
atacar(mago, (_, _, AD), [(NOMBRE, HP, AD)|E1], E2, E1F, E2F) :- bajarAD(E2, E2F, AD), moverAtras((NOMBRE, HP, AD), E1, E1F).
atacar(asesino, (_,_,AD), [(NOMBRE, HP, AD)|E1], E2, E1F, E2F) :- bajarHPAlPrimero(E2,E2F, AD), moverAtras((NOMBRE, HP, AD), E1, E1F).
atacar(tanque, (_,_,AD), [(NOMBRE, HP, AD)|E1], E2, E1F, E2F) :- bajarHP(E2,E2F, AD), moverAtras((NOMBRE, HP, AD), E1, E1F).
atacar(soporte, (_,_,_), [(NOMBRE,HP,AD)|E1], E2, E1F, E2F) :- 
  NOMBRE1 = NOMBRE, HP1 is HP, AD1 is AD,
   buffearEquipo(E1,X,AD),
   append(X, [(NOMBRE1,HP1,AD1)], E1F),
   E2F = E2.

% stepPelea(+E1, +E2, -E1F, -E2F)
stepPelea([(NOMBRE, HP, AD)|E1], E2, E1F, E2F) :- tipo(NOMBRE, TIPO),
  atacar(TIPO, (NOMBRE, HP, AD), [(NOMBRE, HP, AD)|E1], E2, E1F, E2F).

% par(+Y)
par(Y) :- Y mod 2 =:= 0.

% pelea(+E1, +E2, +C, -G)
pelea(E1, E2, C, G) :- peleaAux(E1, E2, _, _, C, G).

% peleaAux(+E1, +E2, -E1F, -E2F, +C, -G)
peleaAux(E1, E2, _, _, 0, E1) :- length(E1, X), length(E2, Y), X > Y.
peleaAux(E1, E2, _, _, 0, E2) :- length(E1, X), length(E2, Y), X < Y.
peleaAux(E1, E2, _, _, 0, []) :- length(E1, X), length(E2, Y), X =:= Y.
peleaAux([], E2, _, _, _, E2).
peleaAux(E1, [], _, _, _, E1).
peleaAux(E1, E2, E1F, E2F, C, G) :- C > 0, stepPelea(E1, E2, E1F, E2F), STEP is C-1, peleaAux(E2F, E1F, _, _, STEP, G).
% peleaAux(E1, E2, E1F, E2F, C, G) :- par(C), C > 0, stepPelea(E1, E2, E1F, E2F), STEP is C-1, peleaAux(E1F, E2F, _, _, STEP, G).
% peleaAux(E1, E2, E1F, E2F, C, G) :- not(par(C)), stepPelea(E2, E1, E2F, E1F), STEP is C-1, peleaAux(E1F, E2F, _, _, STEP, G).

% nombreCampeones(+E, -EF)
nombreCampeones([],[]).
nombreCampeones([(NOMBRE,_,_)|E], [NOMBRE1|EF]) :- NOMBRE1 = NOMBRE, nombreCampeones(E,EF).

% gana(?E1, +E2)
gana(E1, E2) :- equipoValido(E1),
 pelea(E1, E2, 10, G),
  nombreCampeones(G, GANADORES),
   nombreCampeones(E1, CAMPEONES),
   length(GANADORES, X),
   X > 0,
    subset(GANADORES, CAMPEONES).

% hpDiffs(+E, -EF)
hpDiffs([], []).
hpDiffs([(NOMBRE, HP, _)|G], [HP1|GF]) :- campeon((NOMBRE, HP_Original, _)), HP1 is (HP_Original - HP), hpDiffs(G,GF).

% honor(+E1, +E2, -C)
honor(E1,E2,C) :- pelea(E1, E2, 10, G),
 member((NOMBRE,HP,_), G),
  campeon((NOMBRE,HP1,_)),
   hpDiffs(G, LISTA_HP),
    min_list(LISTA_HP, MIN),
     X is HP1 - HP,
     X =:= MIN,
      C = NOMBRE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTS

%nombreCampeones([],[]).
%nombreCampeones([(NOMBRE,_,_)|E], [NOMBRE1|EF]) :- NOMBRE1 = NOMBRE, nombreCampeones(E,EF).

cantidadTestsNombreCampeones(2).
testNombreCampeones(1) :- nombreCampeones([(nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20)], N),
    N = [nami, nami, nami, nami, nami].
testNombreCampeones(2) :- nombreCampeones([(nami,250,20), (teemo,180,80), (akali,200,150)], N),
    N = [nami, teemo, akali].

cantidadTestsSonCampeones(3).
testSonCampeones(1) :- sonCampeones([(nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20), (nami,250,20)]).
testSonCampeones(2) :- sonCampeones([(teemo,180,80), (akali,200,150)]).
testSonCampeones(3) :- not(sonCampeones([(teemo,180,80), (12345,200,150)])).

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

cantidadTestsEquipoValido(6).
testEquipoValido(1) :- campeon(X), equipoValido(E), E = [X].
testEquipoValido(2) :- equipoValido(E), E = [(teemo,180,80), (akali,200,150)].
testEquipoValido(3) :- equipoValido(E), E = [(akali,200,150), (teemo,180,80)].
testEquipoValido(4) :- equipoValido(E), not((E = [(morgana,200,30), (morgana,200,30)])).
% test no repetidos de tipo
testEquipoValido(5) :- equipoValido(E), not((E = [(teemo,180,80), (morgana,200,30)])).
testEquipoValido(6) :- equipoValido(E), not((E = [(techies,180,80), (morgana,200,30), (juggernaut, 200, 150), (pudge, 999, 2)])).

cantidadTestsAtacar(5).
testAtacar(1) :- atacar(soporte, (soraka,300,10), [(soraka,300,10), (teemo,180,80), (evelyn,200,130)], [(soraka,300,10), (teemo,180,80)], E1F, E2F),
    	E1F = [(teemo,190,90), (evelyn,210,140), (soraka,300,10)], E2F = [(soraka,300,10), (teemo,180,80)]. 
testAtacar(2) :- atacar(tanque, (amumu,400,50), [(amumu,400,50), (morgana,200,30)], [(brand,230,40), (chogat,400,50)], E1F, E2F), 
    	E1F = [(morgana,200,30), (amumu,400,50)], E2F = [(brand,180,40), (chogat,350,50)].
testAtacar(3) :- atacar(asesino, (akali, 200, 150), [(akali,200,150)], [(brand,230,40), (chogat,400,50)], E1F, E2F), 
    E1F = [(akali,200,150)], E2F = [(brand,80,40), (chogat,400,50)].
testAtacar(4) :- atacar(mago, (brand,230,40), [(brand,230,40)], [(akali,200,150), (chogat,400,50)], E1F, E2F),
    E1F = [(brand,230,40)], E2F = [(akali,200,110), (chogat,400,10)].
testAtacar(5) :- atacar(asesino, (akali, 200, 150), [(akali,200,150)], [(brand,100,40), (chogat,400,50)], E1F, E2F), 
    E1F = [(akali,200,150)], E2F = [(chogat,400,50)].

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

cantidadTestsGana(6).
testGana(1) :- not(gana([(morgana,200,30)], [(brand,230,40), (chogat,400,50)])).
testGana(2) :- gana([(brand,230,40), (chogat,400,50)], [(morgana,200,30)]).
testGana(3) :- gana([(akali,200,150)], [(evelyn,120,130),(teemo,40,80)]).
testGana(4) :- gana(E, [(akali,200,150)]), E = [(evelyn, 200, 130)].
testGana(5) :- gana(E, [(evelyn, 200, 130)]), member(E, [[(chogat, 400, 50)], [(akali, 200, 150)]]).
testGana(6) :- not(gana([(brand,160,40)], [(teemo,40,80)])).

cantidadTestsHonor(4).
testHonor(1) :- honor([(soraka,300,10), (chogat,400,50)], [(teemo, 50, 0)], C), C = chogat.
testHonor(2) :- honor([(akali,200,150)], [(brand,160,40), (chogat,50,50)], C), C = akali.
testHonor(3) :- honor([(amumu,400,50)], [(brand,230,40), (chogat,400,50)], C), member(C, [brand, chogat]).
testHonor(4) :- honor([(evelyn, 100, 100)], [(akali, 1000, 50), (teemo, 1000, 50)], C), C = teemo.

tests(equipoInfinito) :- cantidadTestsEquipoInfinito(M), forall(between(1,M,N), testEquipoInfinito(N)).
tests(equipoValido) :- cantidadTestsEquipoValido(M), forall(between(1,M,N), testEquipoValido(N)).
tests(stepPelea) :- cantidadTestsStepPelea(M), forall(between(1,M,N), testStepPelea(N)).
tests(pelea) :- cantidadTestsPelea(M), forall(between(1,M,N), testPelea(N)).
tests(gana) :- cantidadTestsGana(M), forall(between(1,M,N), testGana(N)).
tests(honor) :- cantidadTestsHonor(M), forall(between(1,M,N), testHonor(N)).
tests(sonCampeones) :- cantidadTestsSonCampeones(M), forall(between(1,M,N), testSonCampeones(N)).
tests(atacar) :- cantidadTestsAtacar(M), forall(between(1,M,N), testAtacar(N)).
tests(nombreCampeones) :- cantidadTestsNombreCampeones(M), forall(between(1,M,N), testNombreCampeones(N)).

tests(todos) :-
  tests(equipoInfinito),
  tests(equipoValido),
  tests(stepPelea),
  tests(pelea),
  tests(gana),
  tests(gana),
  tests(sonCampeones),
  tests(atacar).
  tests(nombreCampeones).

tests :- tests(todos).