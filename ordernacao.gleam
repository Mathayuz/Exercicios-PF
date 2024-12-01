import sgleam/check
import gleam/list
import gleam/int

pub fn sort(list: List(Int)) -> List(Int) {
  list.sort(list, by: int.compare)
}

pub fn sort_examples() {
  check.eq(sort([3, 2, 1]), [1, 2, 3])
  check.eq(sort([1, 2, 3]), [1, 2, 3])
  check.eq(sort([1, 3, 2]), [1, 2, 3])
  check.eq(sort([3, 1, 2]), [1, 2, 3])
}

/// Implementa o algoritmo de selection sort
pub fn other_sort(list: List(Int)) -> Result(List(Int), String) {
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

pub fn other_sort_examples() {
    check.eq(other_sort([3, 2, 1]), Ok([1, 2, 3]))
    check.eq(other_sort([1, 2, 3]), Ok([1, 2, 3]))
    check.eq(other_sort([1, 3, 2]), Ok([1, 2, 3]))
    check.eq(other_sort([3, 1, 2]), Ok([1, 2, 3]))
}

/// Remove um elemento de uma lista
pub fn remove(elemento: Int, lista: List(Int)) -> Result(List(Int), String) {
  case lista {
    [] -> Error("Elemento não encontrado")
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
  check.eq(remove(4, [1, 2, 3]), Error("Elemento não encontrado"))
}

pub fn encontra_menor(lista: List(Int)) -> Result(Int, String) {
  case lista {
    [] -> Error("A lista está vazia") // Caso especial: lista vazia
    [primeiro] -> Ok(primeiro) // Caso base: lista com um único elemento
    [primeiro, ..resto] -> case encontra_menor(resto) {
      Ok(menor_resto) -> case primeiro < menor_resto {
        True -> Ok(primeiro)
        False -> Ok(menor_resto)
      }
      Error(erro) -> Error(erro)
    }
  }
}

pub fn encontra_menor_examples() {
  check.eq(encontra_menor([1, 2]), Ok(1))
  check.eq(encontra_menor([1]), Ok(1))
  check.eq(encontra_menor([1, 2, 3]), Ok(1))
  check.eq(encontra_menor([2, 1, 3]), Ok(1))
  check.eq(encontra_menor([3, 2, 1]), Ok(1))
  check.eq(encontra_menor([2, 3, 1]), Ok(1))
  check.eq(encontra_menor([1, 3, 2]), Ok(1))
  check.eq(encontra_menor([3, 1, 2]), Ok(1))
}