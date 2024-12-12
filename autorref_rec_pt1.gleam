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

/// Exercício 9
/// Cria uma nova lista removendo as strings vazias de uma *lista*
pub fn remove_vazio(lista: List(String)) -> List(String) {
  case lista {
    [] -> []
    [primeiro, ..resto] -> case primeiro == "" {
      True -> remove_vazio(resto)
      False -> [primeiro, ..remove_vazio(resto)]
    }
  }
}

pub fn remove_vazio_examples() {
  check.eq(remove_vazio([]), [])
  check.eq(remove_vazio([""]), [])
  check.eq(remove_vazio(["a"]), ["a"])
  check.eq(remove_vazio(["", "a", "", "b", "c", ""]), ["a", "b", "c"])
}

/// Exercício 10
pub fn verifica_lista_bool(lista: List(Bool)) -> Bool {
  case lista {
    [] -> True
    [primeiro, ..resto] if primeiro == True -> verifica_lista_bool(resto)
    [_, ..] -> False
  }
}

pub fn verifica_lista_bool_examples() {
  check.eq(verifica_lista_bool([]), True)
  check.eq(verifica_lista_bool([True]), True)
  check.eq(verifica_lista_bool([False]), False)
  check.eq(verifica_lista_bool([True, False]), False)
  check.eq(verifica_lista_bool([False, True]), False)
  check.eq(verifica_lista_bool([True, True]), True)
}

/// Exercício 11
pub fn valor_max(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro] -> Ok(primeiro)
    [primeiro, ..resto] -> case valor_max(resto) {
      Ok(maior) -> case primeiro > maior {
        True -> Ok(primeiro)
        False -> Ok(maior)
      }
      Error(erro) -> Error(erro)
    }
  }
}

pub fn valor_max_examples() {
  check.eq(valor_max([]), Error(Nil))
  check.eq(valor_max([1]), Ok(1))
  check.eq(valor_max([1, 2]), Ok(2))
  check.eq(valor_max([2, 1]), Ok(2))
  check.eq(valor_max([2, 1, 3]), Ok(3))
  check.eq(valor_max([2, 1, 3, 10, 2]), Ok(10))
  check.eq(valor_max([20, 1, 3, 10, 2]), Ok(20))
}

/// Exercício 12
pub fn ordem_nao_decrescente(lista: List(Int)) -> Bool {
  case lista {
    [] -> True
    [primeiro, segundo, ..resto] -> primeiro < segundo && ordem_nao_decrescente([segundo, ..resto])
    [_] -> True
  }
}

pub fn ordem_nao_decrescente_examples() {
  check.eq(ordem_nao_decrescente([]), True)
  check.eq(ordem_nao_decrescente([1]), True)
  check.eq(ordem_nao_decrescente([1, 2]), True)
  check.eq(ordem_nao_decrescente([3, 2]), False)
  check.eq(ordem_nao_decrescente([3, 4, 5]), True)
  check.eq(ordem_nao_decrescente([1, 2, 1]), False)
  check.eq(ordem_nao_decrescente([1, 2, 1, 2]), False)
}

/// Exercício 13
pub fn reverse(lista: List(a)) -> List(a) {
  case lista {
    [] -> []
    [primeiro, ..resto] -> case reverse(resto) {
      [] -> [primeiro]
      [segundo, ..resto] -> adiciona_fim(primeiro, [segundo, ..resto])
    }
  }
}

pub fn reverse_examples() {
  check.eq(reverse([]), [])
  check.eq(reverse([1]), [1])
  check.eq(reverse([1, 2]), [2, 1])
  check.eq(reverse([1, 2, 3]), [3, 2, 1])
  check.eq(reverse([1, 2, 3, 4]), [4, 3, 2, 1])
}

pub fn adiciona_fim(elemento: a, lista: List(a)) -> List(a) {
  case lista {
    [] -> [elemento]
    [primeiro] -> [primeiro, elemento]
    [primeiro, ..resto] -> [primeiro, ..adiciona_fim(elemento, resto)]
  }
}

/// Exercício 14
pub type Associacao {
  Associacao(chave: String, valor: Int)
}

pub fn atualiza_dicionario(lista: List(Associacao), chave: String, valor: Int) -> List(Associacao) {
  case lista {
    [] -> [Associacao(chave, valor)]
    [primeiro, ..resto] -> case busca_chave(lista, chave) {
      True -> case primeiro.chave == chave {
        True -> [Associacao(chave, valor), ..resto]
        False -> list.append([primeiro], atualiza_dicionario(resto, chave, valor))
      }
      False -> list.append(lista, [Associacao(chave, valor)])
    }
  }
}

pub fn atualiza_dicionario_examples() {
  check.eq(atualiza_dicionario([], "lucas", 3), [Associacao("lucas", 3)])
  check.eq(atualiza_dicionario([Associacao("jay", 4)], "lucas", 3), [Associacao("jay", 4), Associacao("lucas", 3)])
  check.eq(atualiza_dicionario([Associacao("lucas", 2)], "lucas", 3), [Associacao("lucas", 3)])
  check.eq(atualiza_dicionario([Associacao("jay", 2), Associacao("lucas", 2)], "lucas", 3), [Associacao("jay", 2), Associacao("lucas", 3)])
  check.eq(atualiza_dicionario([Associacao("jay", 2), Associacao("lucas", 2), Associacao("hito", 10)], "lucas", 3), [Associacao("jay", 2), Associacao("lucas", 3), Associacao("hito", 10)])
}

pub fn busca_chave(lista: List(Associacao), chave: String) -> Bool {
  case lista {
    [] -> False
    [primeiro, ..resto] -> primeiro.chave == chave || busca_chave(resto, chave)
  }
}

