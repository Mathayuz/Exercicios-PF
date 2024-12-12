import sgleam/check
import gleam/string
import gleam/list

/// Exercício 7
pub fn amplitude(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [_] -> Error(Nil)
    [_, .._] -> case max(lista), min(lista) {
      Ok(max), Ok(min) -> Ok(max - min)
      _, _ -> Error(Nil)
    }
  }
}

pub fn amplitude_examples() {
  check.eq(amplitude([]), Error(Nil))
  check.eq(amplitude([1]), Error(Nil))
  check.eq(amplitude([1, 2]), Ok(1))
  check.eq(amplitude([3, 1]), Ok(2))
  check.eq(amplitude([3, 1, 10]), Ok(9))
  check.eq(amplitude([3, 1, 10, 4]), Ok(9))
  check.eq(amplitude([8, 3, 1]), Ok(7))
  check.eq(amplitude([8, 3, 1, 4]), Ok(7))
}

pub fn max(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [unico] -> Ok(unico)
    [primeiro, segundo, ..resto] -> case primeiro > segundo {
      True -> max([primeiro, ..resto])
      False -> max([segundo, ..resto])
    }
  }
}

pub fn min(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [unico] -> Ok(unico)
    [primeiro, segundo, ..resto] -> case primeiro < segundo {
      True -> min([primeiro, ..resto])
      False -> min([segundo, ..resto])
    }
  }
}

/// Exercício 8
pub fn tam_medio_strings(lst: List(String)) -> Result(Int, Nil) {
  case lst {
    [] -> Error(Nil)
    [_, .._] -> Ok(soma_elementos(pega_tamanho(lst)) / list.length(lst))
  }
}

pub fn tam_medio_strings_examples() {
  check.eq(tam_medio_strings([]), Error(Nil))
  check.eq(tam_medio_strings(["a"]), Ok(1))
  check.eq(tam_medio_strings(["abc"]), Ok(3))
  check.eq(tam_medio_strings(["a", "abc"]), Ok(2))
  check.eq(tam_medio_strings(["a", "abc", "a"]), Ok(1))
  check.eq(tam_medio_strings(["a", "abc", "a", "aab"]), Ok(2))
}

pub fn pega_tamanho(lst: List(String)) -> List(Int) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> [string.length(primeiro), ..pega_tamanho(resto)]
  }
}

pub fn soma_elementos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] -> primeiro + soma_elementos(resto)
  }
}

/// Exercício 9
pub fn positivos_ou_negativos(lst: List(Int)) -> String {
  case soma_positivos(lst) - soma_negativos(lst) > 0 {
    True -> "Positivos"
    False -> case soma_positivos(lst) - soma_negativos(lst) < 0 {
      True -> "Negativos"
      False -> "Iguais"
    }
  }
}

pub fn soma_positivos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] if primeiro > 0 -> 1 + soma_positivos(resto)
    [_, ..resto] -> soma_positivos(resto)
  }
}

pub fn soma_negativos(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [primeiro, ..resto] if primeiro < 0 -> 1 + soma_negativos(resto)
    [_, ..resto] -> soma_negativos(resto)
  }
}

pub fn positivos_ou_negativos_examples() {
  check.eq(positivos_ou_negativos([]), "Iguais")
  check.eq(positivos_ou_negativos([0]), "Iguais")
  check.eq(positivos_ou_negativos([1]), "Positivos")
  check.eq(positivos_ou_negativos([1, -1]), "Iguais")
  check.eq(positivos_ou_negativos([1, -1, 0]), "Iguais")
  check.eq(positivos_ou_negativos([-1]), "Negativos")
  check.eq(positivos_ou_negativos([-1, 1]), "Iguais")
  check.eq(positivos_ou_negativos([-1, 0, 1]), "Iguais")
  check.eq(positivos_ou_negativos([1, 2, -3, 0, -4, 2, -3, 10, 0]), "Positivos")
  check.eq(positivos_ou_negativos([1, 2, -3, 0, -4, 2, -3, 10, 0, -3, -10]), "Negativos")
}

/// Exercício 10
pub fn repete(n: Int, v: Int) -> List(Int) {
  case n {
    _ if n <= 0 -> []
    1 -> [v]
    _ -> [v, ..repete(n - 1, v)]
  }
}

pub fn repete_examples() {
  check.eq(repete(-1, 3), [])
  check.eq(repete(0, 2), [])
  check.eq(repete(1, 54), [54])
  check.eq(repete(2, 38), [38, 38])
  check.eq(repete(3, 99), [99, 99, 99])
}

/// Exercício 13
pub fn par(x: Int) -> Bool {
  case x {
    0 -> True
    _ if x > 0 -> impar(x - 1)
    _ -> False
  }
}

pub fn impar(x: Int) -> Bool {
  case x {
    0 -> False
    _ if x > 0 -> par(x - 1)
    _ -> False
  }
}

pub fn par_examples() {
  check.eq(par(3), False)
  check.eq(par(0), True)
  check.eq(par(-3), False)
  check.eq(par(6), True)
}

/// Exercício 14
pub type Arvore(a) {
  Vazia
  No(valor: a, esq: Arvore(a), dir: Arvore(a))
}

pub fn grau_2(arv: Arvore(a)) -> Int {
  case arv {
    Vazia -> 0
    No(_, esq, dir) -> case esq != Vazia && dir != Vazia {
      True -> 1 + grau_2(esq) + grau_2(dir)
      False -> grau_2(esq) + grau_2(dir)
    }
  }
}

pub fn grau_2_examples() {
  //         t3   3
  //            /   \
  //      t2   4     7   t1
  //          / \     \
  //         3  2      1   t0
  let t0 = No(1, Vazia, Vazia)
  let t1 = No(7, Vazia, t0)
  let t2 = No(4, No(3, Vazia, Vazia), No(2, Vazia, Vazia))
  let t3 = No(3, t2, t1)
  check.eq(grau_2(Vazia), 0)
  check.eq(grau_2(t0), 0)
  check.eq(grau_2(t1), 0)
  check.eq(grau_2(t2), 1)
  check.eq(grau_2(t3), 2)
}

/// Novo tipo
pub type Entrada {
  Arq(String)
  Dir(String, List(Entrada))
}