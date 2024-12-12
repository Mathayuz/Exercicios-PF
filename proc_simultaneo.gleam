import sgleam/check
import gleam/string

/// Exercício 3
pub fn verifica_elementos(lst1: List(a), lst2: List(a)) -> Bool {
  case lst1, lst2 {
    [], [] -> True
    [], _ -> False
    _, [] -> True
    [primeiro1, ..resto1], [primeiro2, ..resto2] -> case busca(lst1, primeiro2) {
      True -> case remove(lst1, primeiro2) {
        lista_sem_um -> verifica_elementos(lista_sem_um, resto2)
      }
      False -> False
    }
  }
}

pub fn verifica_elementos_examples() {
  check.eq(verifica_elementos([], []), True)
  check.eq(verifica_elementos([1], [1]), True)
  check.eq(verifica_elementos([1], [2]), False)
  check.eq(verifica_elementos([1, 2], [2]), True)
  check.eq(verifica_elementos([1, 2, 3], [3, 2, 1]), True)
  check.eq(verifica_elementos([0], [0, 0, 0]), False)
}

pub fn busca(lst1: List(a), elemento: a) -> Bool {
  case lst1 {
    [] -> False
    [primeiro, ..resto] -> elemento == primeiro || busca(resto, elemento)
  }
}

pub fn remove(lst1: List(a), elemento: a) -> List(a) {
  case lst1 {
    [] -> []
    [primeiro, ..resto] -> case elemento == primeiro {
      True -> resto
      False -> [primeiro, ..remove(resto, elemento)]
    }
  }
}