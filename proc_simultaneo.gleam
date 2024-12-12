import sgleam/check
import gleam/list
import gleam/int

/// Exercício 3
pub fn verifica_elementos(lst1: List(a), lst2: List(a)) -> Bool {
  case lst1, lst2 {
    [], [] -> True
    [], _ -> False
    _, [] -> True
    [_, .._], [primeiro2, ..resto2] -> case busca(lst1, primeiro2) {
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

/// Exercício 4
pub fn produto_cartesiano(lst1: List(Int), lst2: List(Int)) -> List(List(Int)) {
  case lst1, lst2 {
    [primeiro1, ..resto1], [_, .._] -> list.append(cria_pares(primeiro1, lst2), produto_cartesiano(resto1, lst2))
    _, _ -> []
  }
}

pub fn cria_pares(elemento: Int, list: List(Int)) -> List(List(Int)) {
  case list {
    [] -> []
    [primeiro, ..resto] -> [[elemento, primeiro], ..cria_pares(elemento, resto)]
  }
}

pub fn produto_cartesiano_examples() {
  check.eq(produto_cartesiano([1], [2]), [[1, 2]])
  check.eq(produto_cartesiano([1, 3], [2]), [[1, 2], [3, 2]])
  check.eq(produto_cartesiano([1], [3, 2]), [[1, 3], [1, 2]])
  check.eq(produto_cartesiano([1, 4], [3, 2]), [[1, 3], [1, 2], [4, 3], [4, 2]])
  check.eq(produto_cartesiano([1, 4, 5], [3, 2]), [[1, 3], [1, 2], [4, 3], [4, 2], [5, 3], [5, 2]])
  check.eq(produto_cartesiano([1, 4, 5], [3, 2, 6]), [[1, 3], [1, 2], [1, 6], [4, 3], [4, 2], [4, 6], [5, 3], [5, 2], [5, 6]])
}

/// Exercício 5
pub fn seleciona_elementos(lst1: List(String), lst2: List(Bool)) -> List(String) {
  case lst1, lst2 {
    [], [] -> []
    [primeiro1, ..resto1], [primeiro2, ..resto2] -> case primeiro2 == True {
      True -> list.append([primeiro1], seleciona_elementos(resto1, resto2))
      False -> seleciona_elementos(resto1, resto2)
    }
    _, _ -> []
  }
}

pub fn seleciona_elementos_examples() {
  check.eq(seleciona_elementos(["Jorge", "Amanda", "Pedro", "Joana"], [True, False, False, True]), ["Jorge", "Joana"])
}

/// Exercício 8
pub fn mantem(lst: List(Int), n: Int) -> List(Int) {
  case lst, n {
    _, 0 -> []
    [primeiro, .. resto], _ if n > 0 -> list.append([primeiro], mantem(resto, n - 1))
    _, _ -> []
  }
}

pub fn mantem_examples() {
  check.eq(mantem([10, 40, 70, 20, 3], 2), [10, 40])
}

/// Exercício 9
pub fn descarta(lst: List(Int), n: Int) -> Result(List(Int), Nil) {
  case lst, n {
    [], 0 -> Ok([])
    [], _ if n > 0 -> Error(Nil)
    [primeiro, ..resto], 0 -> Ok([primeiro, ..resto])
    [_, ..resto], _ if n > 0 -> descarta(resto, n - 1)
    _, _ -> Error(Nil)
  }
}

pub fn descarta_examples() {
  check.eq(descarta([], 0), Ok([]))
  check.eq(descarta([], 1), Error(Nil))
  check.eq(descarta([1, 2], 1), Ok([2]))
  check.eq(descarta([10, 40, 70, 20, 3], 2), Ok([70, 20, 3]))
}

/// Exercício 11
pub fn insere_em(lst: List(Int), elemento: Int, posicao: Int) -> List(Int) {
  case lst, posicao {
    [], 0 -> [elemento]
    [], _ -> []
    [_, .._], 0 -> list.append([elemento], lst)
    [primeiro, ..resto], _ -> list.append([primeiro], insere_em(resto, elemento, posicao - 1))
  }
}

pub fn insere_em_examples() {
  check.eq(insere_em([], 2, 0), [2])
  check.eq(insere_em([1], 2, 0), [2, 1])
  check.eq(insere_em([1], 2, 1), [1, 2])
  check.eq(insere_em([1, 3], 2, 1), [1, 2, 3])
  check.eq(insere_em([1, 3, 4], 2, 2), [1, 3, 2, 4])
}

/// Exercício 12
pub fn qnt_livros_iguais(lst1: List(String), lst2: List(String)) -> Int {
  case lst1, lst2 {
    _, [] -> 0
    [], _ -> 0
    [primeiro1, ..resto1], [primeiro2, ..resto2] ->  case primeiro1 == primeiro2 {
      True -> 1 + qnt_livros_iguais(resto1, resto2)
      False -> int.max(qnt_livros_iguais(resto1, lst2), qnt_livros_iguais(lst1, resto2))
    }
  }
}

pub fn qnt_livros_iguais_examples() {
  check.eq(qnt_livros_iguais([], ["a"]), 0)
  check.eq(qnt_livros_iguais(["b"], ["a"]), 0)
  check.eq(qnt_livros_iguais(["d", "b"], ["a", "b"]), 1)
  check.eq(qnt_livros_iguais(["d", "b"], ["a", "b"]), 1)
  check.eq(qnt_livros_iguais(["d", "b"], ["a", "b"]), 1)
  check.eq(qnt_livros_iguais(["d", "b",], ["a", "b", "c"]), 1)
  check.eq(qnt_livros_iguais(["Romeu e Julieto"], ["Romeu e Julieto", "Abracadabra"]), 1)
  check.eq(qnt_livros_iguais(["Romeu e Julieto"], ["Abracadabra", "Romeu e Julieto"]), 1)
}

/// Exercício 13
pub fn vestibular(lista_assinalada: List(Int), lista_gabarito: List(Int)) -> Int {
  case lista_assinalada, lista_gabarito {
    [], _ -> 0
    _, [] -> 0
    [primeiro1, ..resto1], [primeiro2, ..resto2] -> case primeiro1 == primeiro2 {
      True -> 1 + vestibular(resto1, resto2)
      False -> vestibular(resto1, resto2)
    }
  }
}

pub fn vestibular_examples() {
  check.eq(vestibular([1, 2, 3], [1, 2, 3]), 3)
  check.eq(vestibular([2, 3, 1], [1, 2, 3]), 0)
  check.eq(vestibular([2, 3, 2], [1, 2, 2]), 1)
  check.eq(vestibular([2, 2, 2], [1, 2, 2]), 2)
}

/// Questao 1 Prova
pub fn verifica_aumentos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [_] -> 0
    [primeiro, segundo, ..resto] -> case primeiro < segundo {
      True -> 1 + verifica_aumentos([segundo, ..resto])
      False -> verifica_aumentos([segundo, ..resto])
    }
  }
}

pub fn verifica_aumentos_examples() {
  check.eq(verifica_aumentos([]), 0)
  check.eq(verifica_aumentos([1]), 0)
  check.eq(verifica_aumentos([1, 5]), 1)
  check.eq(verifica_aumentos([1, 5, 2, 3]), 2)
  check.eq(verifica_aumentos([1, 5, 6, 8, 1, 0]), 3)
}
