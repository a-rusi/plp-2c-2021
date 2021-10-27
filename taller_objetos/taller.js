// Definiciones de los strings de tipos
const tipoElectrico = 'eléctrico';
const tipoPlanta = 'planta';
const tipoFuego = 'fuego';
const tipoNormal = 'normal';
const tipoAgua = 'agua';
const tipoBicho = 'bicho';

// Definiciones globales (no modificar acá, en cambio, completar las funciones ejercicio_i)
let bulbasaur;
let pikachu;
let pichu;
let raichu;
let Pokemon;
let charmander;
let charmeleon;
let charizard;
let peleaPokemon;
let ditto;

// Ejercicio 1
function ejercicio1() {
  bulbasaur = {
    hp: 300,
    ataquePlacaje: function (enemigo) {
      enemigo.hp = enemigo.hp - 10;
    },
    ataqueLatigoCepa: function (enemigo) {
      enemigo.hp = enemigo.hp - 10;
    },
    tipo: tipoPlanta
  };
  pikachu = {
    hp: 250,
    ataqueImpactrueno: function (enemigo) {
      enemigo.hp = enemigo.hp - 10;
    }
  };
}

// Ejercicio 2
function ejercicio2() {
  raichu = {
    hp: 300,
    ataqueGolpeTrueno: function (enemigo) {
      enemigo.hp = enemigo.hp - 30
    }
  };
  Object.setPrototypeOf(raichu, pikachu);

  pichu = { hp: 100 };

  Object.setPrototypeOf(pikachu, pichu);

  bulbasaur.tipo = tipoPlanta;
  pichu.tipo = tipoElectrico;
}

//TEST: pokemon sin HP y luego setPrototypeOf con Pokemon.prototype
// Ejercicio 3
function ejercicio3() {
  Pokemon = function (hp, ataques, tipo) {
    this.hp = hp;
    Object.assign(this, ataques);
    this.tipo = tipo;
  };

  let ataquesCharmander = { ataqueAscuas: function (enemigo) { enemigo.hp = enemigo.hp - 40 } };
  charmander = new Pokemon(200, ataquesCharmander, tipoFuego);

  Object.setPrototypeOf(pichu, Pokemon.prototype);
  Object.setPrototypeOf(bulbasaur, Pokemon.prototype);

  Pokemon.prototype.atacar = function (nombreDeAtaque, enemigo) {
    if (nombreDeAtaque in this) {
      this[nombreDeAtaque](enemigo);
    } else {
      this.hp = this.hp - 10;
    }
  };
}

// Ejercicio 4
function ejercicio4() {
  Pokemon.prototype.nuevoAtaque = function (nombreDeAtaque, funcionAtaque) {
    this[nombreDeAtaque] = funcionAtaque;
  }

  let ondaTrueno = function (enemigo) {
    enemigo.hp = Math.floor(enemigo.hp / 2);
  }

  pikachu.nuevoAtaque("ataqueOndaTrueno", ondaTrueno);
}


// Ejercicio 5
function ejercicio5() {
  Pokemon.prototype.evolucionar = function () {
    evolucion = new Pokemon(this.hp * 2, {}, this.tipo);
    Object.setPrototypeOf(evolucion, this);
    return evolucion;
  }
  charmeleon = charmander.evolucionar();
  charizard = charmeleon.evolucionar();
}

// Ejercicio 6
function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function ejercicio6() {
  Pokemon.prototype.algunAtaque = function () {
    let keys = Object.keys(this);

    while (true) {
      numeroRandom = getRandomInt(keys.length);
      if (keys[numeroRandom] != "hp" && keys[numeroRandom] != "tipo" && keys[numeroRandom] != "atacar") {
        return keys[numeroRandom];
      }
    }
  }
  peleaPokemon = function (pokemon1, pokemon2) {
    atacante = pokemon1;
    defensor = pokemon2;
    while (true) {
      ataque = atacante.algunAtaque();
      atacante.atacar(ataque, defensor);
      if (defensor.hp <= 0) {
        return atacante;
      }
      swap = atacante;
      atacante = defensor;
      defensor = swap;
    }
  }
}

// Ejercicio 7
function ejercicio7() {
  let ataqueCopiarFunc = function (enemigo) {
    ataqueEnemigo = enemigo.algunAtaque();
    this.nuevoAtaque(ataqueEnemigo, enemigo[ataqueEnemigo]);
  }
  ditto = new Pokemon(100, { "ataqueCopiar": ataqueCopiarFunc }, tipoNormal);
}

// Test Ejercicio 1
function testEjercicio1(res) {
  res.write(`El hp de Pikachu es ${pikachu.hp}.`, pikachu.hp === 250);
  let pikachuConoceImpactrueno = 'ataqueImpactrueno' in pikachu;
  res.write(`Pikachu ${si_o_no(pikachuConoceImpactrueno)} conoce impactrueno.`, pikachuConoceImpactrueno);
  let squirtle = { hp: 200 };
  res.write(`\n Creamos a Squirtle, con ${squirtle.hp} de hp.`);
  bulbasaur.ataquePlacaje(squirtle);
  res.write(`Después de ser atacado una vez por Bulbasaur, el hp de Squirtle es de ${squirtle.hp}.`, squirtle.hp === 190);

  //Completar
  res.write(`El hp de Bulbasaur es ${bulbasaur.hp}.`, bulbasaur.hp === 300);
  let bulbasaurConoceLatigoCepa = 'ataqueLatigoCepa' in bulbasaur;
  res.write(`Bulbsaur ${si_o_no(bulbasaurConoceLatigoCepa)} conoce latigo cepa.`, bulbasaurConoceLatigoCepa);
  let bulbasaurConocePlacaje = 'ataquePlacaje' in bulbasaur;
  res.write(`Bulbsaur ${si_o_no(bulbasaurConocePlacaje)} conoce placaje.`, bulbasaurConocePlacaje);
}

// Test Ejercicio 2
function testEjercicio2(res) {
  let caterpie = { hp: 100 }
  res.write(`Creamos a Caterpie, con ${caterpie.hp} de hp.`);
  res.write(`El hp de Raichu es ${raichu.hp}.`, raichu.hp === 300);
  raichu.ataqueImpactrueno(caterpie);
  res.write(`Raichu usa impactrueno contra Caterpie, por lo que su hp es ${caterpie.hp}.`, caterpie.hp === 90);
  raichu.ataqueGolpeTrueno(caterpie);
  res.write(`Después, si usa golpeTrueno, el hp de Caterpie es ${caterpie.hp}.`, caterpie.hp === 60);

  let pikachuConocePararrayo = 'ataquePararrayo' in pikachu;
  res.write(`\n Pikachu ${si_o_no(pikachuConocePararrayo)} tiene definido pararrayo,`, !pikachuConocePararrayo);
  pichu.ataquePararrayo = function (otroPoke) {
    otroPoke.hp -= 10;
  };
  let pikachuConocePararrayoAhora = pikachu.ataquePararrayo == pichu.ataquePararrayo;
  res.write(`pero ${si_o_no(pikachuConocePararrayoAhora)} lo tiene definido una vez que se le define a Pichu.`, pikachuConocePararrayoAhora);
  let raichuConocePararrayo = raichu.ataquePararrayo == pichu.ataquePararrayo;
  res.write(`Raichu ${si_o_no(raichuConocePararrayo)} conoce pararrayo.`, raichuConocePararrayo);
  let pikachuEsDeTipoElectrico = pikachu.tipo == tipoElectrico;
  res.write(`Pikachu ${si_o_no(pikachuEsDeTipoElectrico)} es de tipo eléctrico como Pichu.`, pikachuEsDeTipoElectrico);

  //Completar
  let pichuNoConoceImpactTrueno = pichu.ataqueImpactrueno == undefined;
  res.write(`Pichu no conoce ataques de Pikachu`, pichuNoConoceImpactTrueno);
  let pikachuNoConoceGolpeTrueno = pikachu.ataqueGolpeTrueno == undefined;
  res.write(`Pikachu no conoce ataques de Raichu`, pikachuNoConoceGolpeTrueno);

  let bulbsaurEsDeTipoPlanta = bulbasaur.tipo == tipoPlanta;
  res.write(`Bulbsaur ${si_o_no(bulbsaurEsDeTipoPlanta)} es de tipo planta`, bulbsaurEsDeTipoPlanta);
}

// Test Ejercicio 3
function testEjercicio3(res) {
  let pikachuConoceGolpeTrueno = 'ataqueGolpeTrueno' in pikachu;
  res.write(`Se mantiene la jerarquía de antes, Pikachu ${si_o_no(pikachuConoceGolpeTrueno)} tiene definido golpeTrueno.`, !pikachuConoceGolpeTrueno);
  let charmanderConoceAscuas = 'ataqueAscuas' in charmander;
  res.write(`Charmander ${si_o_no(charmanderConoceAscuas)} tiene definido ascuas.`, charmanderConoceAscuas);


  let pidgey = new Pokemon(200, {}, tipoNormal);
  res.write(`\n Creamos a Pidgey, con ${pidgey.hp} de hp.`);
  pikachu.atacar("ataqueImpactrueno", pidgey);
  res.write(`Pidgey es atacado por Pikachu, y ahora tiene un hp de ${pidgey.hp},`, pidgey.hp == 190);
  let pikachuConMismoHp = pikachu.hp == 250;
  res.write(`y el hp de Pikachu ${si_o_no(!pikachuConMismoHp)} se ve afectado.`, pikachuConMismoHp);

  pidgey.atacar("ataqueLatigoCepa", raichu);
  res.write(`Pidgey intenta atacar a Raichu con un ataque que no conoce, pero termina con hp de ${pidgey.hp},`, pidgey.hp == 180);
  let raichuConMismoHp = raichu.hp == 300;
  res.write(`y el hp de Raichu ${si_o_no(!raichuConMismoHp)} se ve afectado.`, raichuConMismoHp);

  //Completar
  let bulbasaurConoceAtacar = 'atacar' in bulbasaur;
  res.write(`Bulbasaur ${si_o_no(bulbasaurConoceAtacar)} conoce atacar.`, bulbasaurConoceAtacar);
}

// Test Ejercicio 4
function testEjercicio4(res) {
  let ekans = new Pokemon(250, {}, tipoPlanta);
  res.write(`Creamos a Ekans, con ${ekans.hp} de hp.`);
  pikachu.ataqueOndaTrueno(ekans);
  res.write(`Atacar a Ekans con el nuevo ataque ondaTrueno le deja ${ekans.hp} de hp.`, ekans.hp == 125);
  let pichuConoceOndaTrueno = 'ataqueOndaTrueno' in pichu;
  res.write(`Pichu ${si_o_no(pichuConoceOndaTrueno)} puede atacar usando ondaTrueno,`, !pichuConoceOndaTrueno);
  let raichuConoceOndaTrueno = raichu.ataqueOndaTrueno == pikachu.ataqueOndaTrueno;
  res.write(`y Raichu ${si_o_no(raichuConoceOndaTrueno)} puede.`, raichuConoceOndaTrueno);

  //Completar
  let bulbasaurConoceNuevoAtaque = 'nuevoAtaque' in bulbasaur;
  res.write(`Bulbasaur ${si_o_no(bulbasaurConoceNuevoAtaque)} conoce nuevoAtaque.`, bulbasaurConoceNuevoAtaque);

  //pokemon se puede atacar a si mismo, tambien tener hp negativa
  let autoDestruccion = function (enemigo) {
    enemigo.hp = enemigo.hp - 1000;
  }
  let golem = new Pokemon(550, {}, tipoNormal);
  golem.nuevoAtaque('ataqueAutoDestruccion', autoDestruccion);
  let golemConoceAutoDestruccion = 'ataqueAutoDestruccion' in golem;
  res.write(`Golem ${si_o_no(golemConoceAutoDestruccion)} conoce ataqueAutoDestruccion.`, golemConoceAutoDestruccion);
  golem.ataqueAutoDestruccion(golem);
  res.write(`Golem se autodestruyo! Su vida ahora es negativa`, golem.hp < 0);

}

// Test Ejercicio 5
function testEjercicio5(res) {
  let charmeleonTieneDobleHp = charmeleon.hp == 2 * charmander.hp;
  res.write(`Charmeleon ${si_o_no(charmeleonTieneDobleHp)} tiene el doble de hp de Charmander.`, charmeleonTieneDobleHp);
  let charizardTieneCuadrupleHp = charizard.hp == 4 * charmander.hp;
  res.write(`Charizard ${si_o_no(charizardTieneCuadrupleHp)} tiene cuatro veces el hp de Charmander.`, charizardTieneCuadrupleHp);

  res.write(`\n Charmander aprende ascuasEmber.`);
  charmander.nuevoAtaque("ataqueAscuasEmber", function (otroPoke) { otroPoke.hp -= 10 });
  let charmeleonConoceAscuasEmber = charmeleon.ataqueAscuasEmber == charmander.ataqueAscuasEmber;
  res.write(`Charmeleon ${si_o_no(charmeleonConoceAscuasEmber)} puede atacar con ascuasEmber,`, charmeleonConoceAscuasEmber);
  let charizardConoceAscuasEmber = charizard.ataqueAscuasEmber == charmander.ataqueAscuasEmber;
  res.write("Charizard también.", charizard.ataqueAscuasEmber == charmander.ataqueAscuasEmber);

  res.write(`\n Charmeleon aprende lanzallamas.`);
  charmeleon.nuevoAtaque("ataqueLanzallamas", function (otroPoke) { otroPoke.hp -= 10 });
  let charmanderConoceLanzallamas = 'ataqueLanzallamas' in charmander;
  res.write(`Charmander ${si_o_no(charmanderConoceLanzallamas)} conoce el ataque lanzallamas de Charmeleon.`, !charmanderConoceLanzallamas);

  //Completar
  let ivysaur = bulbasaur.evolucionar()

  ivysaurConoceLatigoCepa = 'ataqueLatigoCepa' in ivysaur;
  res.write(`Ivysaur ${si_o_no(ivysaurConoceLatigoCepa)} conoce el ataque latigocepa de Bulbasaur.`, ivysaurConoceLatigoCepa);
  ivysaurEsDeTipoPlanta = ivysaur.tipo == tipoPlanta;
  res.write(`Ivysaur ${si_o_no(ivysaurEsDeTipoPlanta)} es tipo planta como Bulbasaur.`, ivysaurEsDeTipoPlanta);
  ivysaurTieneDobleDeVida = bulbasaur.hp * 2 == ivysaur.hp;
  res.write(`Ivysaur ${si_o_no(ivysaurTieneDobleDeVida)} tiene el doble de vida que Bulbasaur.`, ivysaurTieneDobleDeVida);

  ivysaur.nuevoAtaque('ataqueHoja', function (enemigo) { });
  ivysaurConoceAtaqueHoja = 'ataqueHoja' in ivysaur;
  bulbasaurConoceAtaqueHoja = 'ataqueHoja' in bulbasaur;

  res.write(`Ivysaur ${si_o_no(ivysaurConoceAtaqueHoja)} si conoce ataque hoja.`, ivysaurConoceAtaqueHoja);
  res.write(`Bulbasaur no deberia conocer ${si_o_no(!bulbasaurConoceAtaqueHoja)}  ataque hoja.`, !bulbasaurConoceAtaqueHoja);



}

// Test Ejercicio 6
function testEjercicio6(res) {
  let bulbasaurConoceAlgunAtaque = 'algunAtaque' in bulbasaur;
  res.write(`Bulbasaur ${si_o_no(bulbasaurConoceAlgunAtaque)} puede responder al mensaje algunAtaque.`, 'algunAtaque' in bulbasaur);

  res.write("\n Creamos a Magikarp.");
  let magikarp = new Pokemon(300, { ataqueSalpicadura: function (oponente) { oponente.hp -= 10; } }, tipoAgua);
  let magikarpConoceAlgunAtaque = 'algunAtaque' in magikarp;
  res.write(`Magikarp ${si_o_no(magikarpConoceAlgunAtaque)} puede responder al mensaje algunAtaque.`, magikarpConoceAlgunAtaque);
  let nombreDeAlgunAtaque = magikarp.algunAtaque();
  let algunAtaqueEsSalpicadura = nombreDeAlgunAtaque == 'ataqueSalpicadura';
  res.write(`Cuando le pedimos algún ataque a Magikarp, ${si_o_no(algunAtaqueEsSalpicadura)} devuelve salpicadura.`, algunAtaqueEsSalpicadura);

  res.write("\n Creamos a Kakuna.");
  let kakuna = new Pokemon(10, { ataqueFortaleza: function (oponente) { } }, tipoBicho);
  let ganador = peleaPokemon(kakuna, magikarp);
  let elGanadorEsMagikarp = 'ataqueSalpicadura' in ganador;
  res.write(`Pelean Kakuna y Magikarp, el ganador ${si_o_no(elGanadorEsMagikarp)} es Magikarp.`, elGanadorEsMagikarp);
  res.write(`El hp de Kakuna después de pelear es ${kakuna.hp}.`, kakuna.hp == 0);

  // Completar
  let scyther = new Pokemon(400, { 'ataqueCorte': function (enemigo) { enemigo.hp = enemigo.hp - 1000 } }, 'bicho');
  let scytherAlgunAtaqueDevuelveSuUnicoAtaque = scyther.algunAtaque() == 'ataqueCorte';
  res.write(`scyther tiene un solo ataque, asi que ${si_o_no(scytherAlgunAtaqueDevuelveSuUnicoAtaque)} devuelve corte.`, scytherAlgunAtaqueDevuelveSuUnicoAtaque);

  // nos aseguramos que el primer pokemon ataque primero, dandole un ataque le hace ganar inmediatamente
  ratata = new Pokemon(30, { 'ataqueMirarMal': function (enemigo) { enemigo.hp = enemigo.hp - 1 } }, 'normal');

  let ganador2 = peleaPokemon(scyther, ratata);
  let elGanadorEsScyther = 'ataqueCorte' in ganador2;
  res.write(`Pelean Scyther y Ratata, el ganador ${si_o_no(elGanadorEsScyther)} es Scyther.`, elGanadorEsScyther);
  res.write("Ratata no pudo lastimar a Scyther", scyther.hp == 400);
  res.write("Ratata tiene hp negativa despues de la pelea", ratata.hp < 0);

  // ambos pokemones atacan
  venonat = new Pokemon(30, { 'ataqueMirarBien': function (enemigo) { enemigo.hp = enemigo.hp - 1 } }, 'normal')
  let ganador3 = peleaPokemon(venonat, scyther);
  let elGanadorEsScyther2 = 'ataqueCorte' in ganador3;
  res.write(`Pelean Scyther y Venonat, el ganador ${si_o_no(elGanadorEsScyther2)} es Scyther.`, elGanadorEsScyther2);
  res.write("Venonat pudo lastimar a Scyther", scyther.hp == 399);


}

// Test Ejercicio 7
function testEjercicio7(res) {
  let dittoConoceCopiar = 'ataqueCopiar' in ditto;
  res.write(`Ditto ${si_o_no(dittoConoceCopiar)} conoce el ataque copiar.`, dittoConoceCopiar);

  res.write("\n Creamos a Butterfree, que conoce el ataque polvoVeneno.");
  let butterfree = new Pokemon(100, { ataquePolvoVeneno: function (oponente) { oponente.hp -= 10; } }, tipoBicho);
  res.write("Ditto ataca a Butterfree con copiar.");
  ditto.ataqueCopiar(butterfree);
  let dittoConocePolvoVeneno = 'ataquePolvoVeneno' in ditto;
  res.write(`Ahora Ditto ${si_o_no(dittoConocePolvoVeneno)} conoce el ataque polvoVeneno.`, dittoConocePolvoVeneno);

  // Completar
  // la funcion de ataque polvo veneno deberia ser la misma entre ditto y butterfree
  res.write("La funcion copiada por Ditto tiene el mismo comportamiento", ditto.ataquePolvoVeneno == butterfree.ataquePolvoVeneno)


}

// Función auxiliar que crea un test genérico a partir de un número i y una función f
function crearTest(i, f) {
  return function () {
    if (eval("typeof ejercicio" + i) !== "undefined") {
      eval("ejercicio" + i)();
    }
    let res = {
      text: "",
      write: function (s, t) {
        if (t != undefined) {
          if (t) s = "<span style='color:green'>" + s + "</span>";
          else s = "<span style='color:red'>" + s + "</span>";
        }
        s += "\n";
        this.text += s;
      }
    };
    try {
      f(res);
    } catch (e) {
      fail(i, e);
    }
    return res.text;
  }
}
