import gleam/list
import gleam/int
import gleam/string
import sgleam/check

pub fn converte_natural(numero: Int) -> String {
  case numero < 10 {
    True -> case numero {
      0 -> "0"
      1 -> "1"
      2 -> "2"
      3 -> "3"
      4 -> "4"
      5 -> "5"
      6 -> "6"
      7 -> "7"
      8 -> "8"
      9 -> "9"
      _ -> ""
    }
    False -> converte_natural(numero / 10) <> converte_natural(numero % 10)
  }
}

pub fn converte_natural_examples() {
  check.eq(converte_natural(1), "1")
  check.eq(converte_natural(10), "10")
  check.eq(converte_natural(190), "190")
}

pub fn inverte_string(string: String) -> String {
  case string.length(string) <= 1 {
    True -> string
    False -> string.slice(string, string.length(string) - 1, 1) <> inverte_string(string.slice(string, 1, string.length(string) - 2)) <> string.slice(string, 0, 1)
  }
}

pub fn inverte_string_examples() {
  check.eq(inverte_string(""), "")
  check.eq(inverte_string("a"), "a")
  check.eq(inverte_string("ab"), "ba")
  check.eq(inverte_string("abc"), "cba")
  check.eq(inverte_string("abca"), "acba")
}

pub fn encontra_maximo(lista: List(Int)) -> Int {
  case lista {
    [unico] -> unico
    _ -> int.max(encontra_maximo(list.take(lista, list.length(lista) / 2)), encontra_maximo(divide_depois(lista, list.length(lista) / 2)))
  }
}

pub fn divide_depois(lista: List(Int), tamanho: Int) -> List(Int) {
  case lista, tamanho {
    [_, ..resto], x if x > 0 -> divide_depois(resto, tamanho - 1)
    _, 0 -> lista
    _, _ -> lista
  }
}

pub fn encontra_maximo_examples() {
  check.eq(encontra_maximo([1]), 1)
  check.eq(encontra_maximo([1, 2]), 2)
  check.eq(encontra_maximo([1, 2, 3]), 3)
  check.eq(encontra_maximo([1, 2, 3, 4]), 4)
  check.eq(encontra_maximo([1, 4, 3, 2]), 4)
}