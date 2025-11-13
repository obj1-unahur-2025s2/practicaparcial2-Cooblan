class Personaje {
  const property fuerza
  const property inteligencia
  var property rol

  method potencialOfensivo() {return fuerza * 10 + rol.condicionExtra()}
  method esInteligente()
  method esGroso() {return rol.esGroso(self)}
}

class Orcos inherits Personaje{
  override method potencialOfensivo() {return super() + rol.brutalidadInnata(super())}
  override method esInteligente() {return false}
  override method esGroso() {return self.esInteligente() or super()}
}

class Humanos inherits Personaje {
  override method esInteligente() {return inteligencia > 50}
  override method esGroso() {return super() or self.esInteligente()}
}

object guerrero {
  method condicionExtra() {return 100}
  method brutalidadInnata(unValor) {return 0}
  method esGroso(unPersonaje){return unPersonaje.fuerza() > 50}
}

object brujo {
  method condicionExtra() {return 0}
  method brutalidadInnata(unValor) {return unValor * 0.1}
  method esGroso(unPersonaje) {return true}

}

class Cazador {
  var property mascota = sinMascota
  method brutalidadInnata(unValor) {return 0}
  method esGroso(unPersonaje) {return mascota.edad() > 10}

}

object sinMascota{
  const property fuerza = 0
  const property edad = 0
  const property tieneGarras = false
}

class Mascota {
  const property fuerza
  const property edad
  const property tieneGarras

  method potencialOfensivo() = if(tieneGarras) fuerza * 2 else fuerza
  method initialize() {
    if(fuerza > 100) {
      self.error("la mascota no puede tener mas de 100 de fuerza")
    }
  }
}


class Localidad {
  var property ejercito

  method enlistar(unPersonaje) {
    ejercito.agregar(unPersonaje)
  }
  method poderDefensivo() = ejercito.potencial()
  method serOcupada(unEjercito)
}

class Aldea inherits Localidad{
  const property habitantes = []
  const property cantMaxHabitantes

  override method enlistar(unPersonaje) {
    if(ejercito.personajes().size() >= cantMaxHabitantes) {
      self.error("ejercito completo")
    }
    super(unPersonaje)
  }
  override method serOcupada(unEjercito) {
    ejercito.clear()
    unEjercito.diezMasFuertes().forEach({p => self.enlistar(p)})
    unEjercito.quitarLosMasFuertes(cantMaxHabitantes.min(10))
  }
}

class Ciudad inherits Localidad{
  const property habitantes = []

  override method poderDefensivo() {
    return 
    super() + 300
  }
  override method serOcupada(unEjercito) {
    ejercito = unEjercito
  } 
}

class Ejercito {
  const property personajes = #{}

  method agregar(unPersonaje) {personajes.add(unPersonaje)}
  method potencial() = personajes.sum({p => p.potencialOfensivo()})
  method invadir(unaLocalidad) {
    if(self.puedeInvadir(unaLocalidad)) {
      unaLocalidad.serOcupada(self)
    }
  }
  method puedeInvadir(unaLocalidad) {
    return self.potencial() > unaLocalidad.poderDefensivo()
  }
  method diezMasFuertes() = self.listaOrdenadaPorPoder().take(10)
  method listaOrdenadaPorPoder() {
    return personajes.asList().sortBy({p1,p2=>p1.potencialOfensivo() > p2.potencialOfensivo()})
  }
  method quitarLosMasFuertes(cantidad) {
    personajes.removeAll(self.diezMasFuertes().take(cantidad))
  }
}



