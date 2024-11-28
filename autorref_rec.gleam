import gleam/int
import gleam/list
import sgleam/check

/// Exercício 6
/// Concatena todos os elementos de uma *lst* de strings
pub fn concatena_lista(lst: List(String)) -> String {
  case lst {
    [] -> ""
    [primeiro] -> primeiro
    [primeiro, ..resto] -> primeiro <> " " <> concatena_lista(resto)
  }
}

pub fn concatena_lista_examples() {
  check.eq(concatena_lista([]), "")
  check.eq(concatena_lista(["Gabriel"]), "Gabriel")
  check.eq(concatena_lista(["Gabriel", "Libar"]), "Gabriel Libar")
  check.eq(concatena_lista(["Gabriel", "Libar", "Lulu"]), "Gabriel Libar Lulu")
}

/// Exercício 7
/// Determina a quantidade de elementos de uma *lst* de números
pub fn qnt_elementos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [_, ..resto] -> 1 + qnt_elementos(resto)
  }
}

pub fn qnt_elementos_examples() {
  check.eq(qnt_elementos([]), 0)
  check.eq(qnt_elementos([3]), 1)
  check.eq(qnt_elementos([1, 3]), 2)
  check.eq(qnt_elementos([1, 2, 4]), 3)
}

/// Exercício 8
/// Cria uma lista de números a partir de uma *lst* de strings
pub fn converte_lista(lst: List(String)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> case int.parse(primeiro) {
        Ok(primeiro) -> [primeiro, ..converte_lista(resto)]
        Error(Nil) -> converte_lista(resto)
    }
  }
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), [])
  check.eq(converte_lista(["0"]), [0])
  check.eq(converte_lista(["-1", "2"]), [-1, 2])
  check.eq(converte_lista(["-10", "504", "352"]), [-10, 504, 352])
}
