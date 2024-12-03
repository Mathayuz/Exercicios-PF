import sgleam/check

/// Verifica os 2 menores números de cada uma das listas e devolve a diferença entre eles,
/// depois verifica os 2 segundos menores números de cada uma das listas e soma com o valor obtido
/// anteriormente, e assim continua até o fim das duas listas, no fim retorna a soma das diferenças entre
/// os menores valores da cada lista
pub fn soma_menores(lista1: List(Int), lista2: List(Int)) -> Result(Int, Nil) {
  case lista1, lista2 {
    [], [] -> Error(Nil)
    [primeiro1, ..resto1], [primeiro2, ..resto2] -> case encontra_menor(lista1), encontra_menor(lista2) {
      Ok(menor1), Ok(menor2) -> case 
    }
  }
}

pub fn soma_menores_examples() {
  check.eq(soma_menores([3], [1]), 2)
  check.eq(soma_menores([3], [3]), 0)
  check.eq(soma_menores([3], [4]), 1)
  check.eq(soma_menores([3, 4, 2, 10], [4, 5, 16, 4]), 10)
}

pub fn lista_menores(x: Int, y: Int) -> List(Int) {
  [x + y]
}

pub fn lista_menores_examples() {
  check.eq(lista_menores(1, 2), [3])
  check.eq(lista_menores(2, 2), [4])
  check.eq(lista_menores(2, 8), [10])
}

pub fn soma_lista(lista: List(Int)) -> Int {
  case lista {
    [] -> 0
    [primeiro, ..resto] -> primeiro + soma_lista(resto)
  }
}

pub fn soma_lista_examples() {
  check.eq(soma_lista([]), 0)
  check.eq(soma_lista([1]), 1)
  check.eq(soma_lista([1, 2]), 3)
  check.eq(soma_lista([3, 1, 2]), 6)
}

pub fn encontra_menor(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro] -> Ok(primeiro)
    [primeiro, ..resto] -> case encontra_menor(resto) {
      Ok(menor) -> case primeiro < menor {
        True -> Ok(primeiro)
        False -> Ok(menor)
      }
      Error(erro) -> Error(erro)
    }
  }
}

pub fn encontra_menor_examples() {
  check.eq(encontra_menor([]), Error(Nil))
  check.eq(encontra_menor([1]), Ok(1))
  check.eq(encontra_menor([1, 2]), Ok(1))
  check.eq(encontra_menor([2, 1]), Ok(1))
  check.eq(encontra_menor([3, 1, 2]), Ok(1))
}

pub fn remove(elemento: Int, lista: List(Int)) -> Result(List(Int), Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro, ..resto] -> case primeiro == elemento {
      True -> Ok(resto)
      False -> case remove(elemento, resto) {
        Ok(resto_sem_elemento) -> Ok([primeiro, ..resto_sem_elemento])
        Error(erro) -> Error(erro)
      }
    }
  }
}

pub fn remove_examples() {
  check.eq(remove(1, [1, 2, 3]), Ok([2, 3]))
  check.eq(remove(2, [1, 2, 3]), Ok([1, 3]))
  check.eq(remove(3, [1, 2, 3]), Ok([1, 2]))
  check.eq(remove(4, [1, 2, 3]), Error(Nil))
}