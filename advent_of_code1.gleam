import sgleam/check
import gleam/int

pub fn soma_menores(lista1: List(Int), lista2: List(Int)) -> Result(Int, Nil) {
  case lista1, lista2 {
    [], [] -> Error(Nil)
    [primeiro1, ..resto1], [primeiro2, ..resto2] -> case other_sort(lista1), other_sort(lista2) {
      Ok(lista1_ordenada), Ok(lista2_ordenada) -> case lista1_ordenada, lista2_ordenada {
        [], [] -> Ok([])
        [primeiro1, ..resto1], [primeiro2, ..resto2] -> case remove(primeiro1, lista1), remove(primeiro2, lista2) {
          Ok(lista1_sem_primeiro), Ok(lista2_sem_primeiro) -> Ok(soma_lista([int.absolute_value(primeiro1 - primeiro2), ..soma_menores(lista1_sem_primeiro, lista2_sem_primeiro)]))
          _, _ -> Error(Nil)
        }
      }
      _, _ -> Error(Nil)
    }
  }
}

pub fn soma_menores_examples() {
  check.eq(soma_menores([3], [1]), Ok(2))
  check.eq(soma_menores([3], [3]), Ok(2))
  check.eq(soma_menores([3], [4]), Ok(2))
  check.eq(soma_menores([3, 4, 2, 10], [4, 5, 16, 4]), Ok(2))
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

pub fn other_sort(list: List(Int)) -> Result(List(Int), Nil) {
  case list {
    [] -> Ok([])
    [primeiro] -> Ok([primeiro])
    [primeiro, ..resto] -> case encontra_menor(resto) {
      Ok(menor) -> case primeiro < menor {
        True -> case other_sort(resto) {
          Ok(resto_ordenado) -> Ok([primeiro, ..resto_ordenado])
          Error(erro) -> Error(erro)
        }
        False -> case remove(menor, list) {
          Ok(list_sem_menor) -> case other_sort(list_sem_menor) {
            Ok(resto_ordenado) -> Ok([menor, ..resto_ordenado])
            Error(erro) -> Error(erro)
          }
          Error(erro) -> Error(erro)
        }
      }
      Error(erro) -> Error(erro)
    }
  }
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