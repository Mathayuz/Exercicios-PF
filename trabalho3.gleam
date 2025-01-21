// Matheus Cenerini Jacomini RA: 134700, Caetano Vendrame Mantovani RA: 135846.

import gleam/int
import gleam/list
import gleam/result
import gleam/string
import sgleam/check

// Desenvolver um programa que recebe uma expressão na notação infixa
// do tipo string e calcula o valor dessa expressão. O programa
// deve implementar um algoritmo para converter a expressão infixa
// em uma expressão pós-fixa e, em seguida, calcular o valor da
// expressão pós-fixa. 

// O programa deve ser capaz de lidar com expressões que contêm
// números inteiros e operadores aritméticos como adição (+),
// subtração (-), multiplicação (*) e divisão (/). O programa deve
// ser capaz de lidar com expressões que contêm parênteses para
// definir a precedência dos operadores.
// O programa deve tratar expressões inválidas.

/// Os possíveis erros que podem ocorrer.
pub type Erros {
  // Erro de divisão por zero.
  DivisaoPorZero
  // Erro de expressão inválida.
  ExpressaoInvalida
  // Erro de parênteses inválidos.
  ParentesesInvalidos
}

/// Um símbolo de uma expressão
pub type Simbolo {
  // Número inteiro.
  Operando(numero: Int)
  // Operador aritmético.
  Operador(operador: String)
  // Parêntese de abertura.
  ParenteseAbre
  // Parêntese de fechamento.
  ParenteseFecha
}

/// Realiza a avaliação de uma expressão na notação pós-fixa.
pub fn avalia_pos_fixa(lista: List(Simbolo)) -> Int {
  let resultado = list.fold(lista, [], avalia_pos_fixa_aux)
  case resultado {
    [Operando(valor)] -> valor
    _ -> 0
  }
}

pub fn avalia_pos_fixa_examples() {
  check.eq(avalia_pos_fixa([Operando(1)]), 1)
  check.eq(avalia_pos_fixa([Operando(1), Operando(2), Operador("+")]), 3)
  check.eq(avalia_pos_fixa([Operando(1), Operando(2), Operador("+"), Operando(3), Operador("*")]), 9)
  check.eq(avalia_pos_fixa([Operando(3), Operando(2), Operador("-"), Operando(4), Operador("*"), Operando(4), Operador("/")]), 1)
}

pub fn avalia_pos_fixa_aux(pilha: List(Simbolo), simbolo: Simbolo) -> List(Simbolo) {
  case simbolo {
    Operando(numero) -> list.append(pilha, [Operando(numero)])
    Operador(operador) -> [Operando(aplica_operador(pilha, operador))]
    ParenteseAbre -> []
    ParenteseFecha -> []
  }
}

pub fn aplica_operador(pilha: List(Simbolo), operador: String) -> Int {
  case pilha {
    [Operando(primeiro), Operando(segundo)] -> case operador {
      "+" -> primeiro + segundo
      "-" -> primeiro - segundo
      "*" -> primeiro * segundo
      "/" -> primeiro / segundo
      _ -> 0
    }
    _ -> 0
  }
}

/// Converte uma expressão infixa em uma expressão pós-fixa.
pub fn converte_infixa(expressao: List(Simbolo)) -> List(Simbolo) {
  todo
}

/// Converte uma expressão do tipo string em uma lista de símbolos.
pub fn converte_string(expressao: String) -> Result(List(Simbolo), Erros) {
  todo
}

/// Função principal que recebe uma expressão infixa e calcula o valor da expressão.
pub fn calcula_expressao(expressao: String) -> Result(Int, Erros) {
  use simbolos <- result.try(converte_string(expressao))
  simbolos
  |> converte_infixa
  |> avalia_pos_fixa
  |> Ok
}

pub fn calcula_expressao_examples() {
  check.eq(calcula_expressao("1"), Ok(1))
  check.eq(calcula_expressao("1 + 2"), Ok(3))
  check.eq(calcula_expressao("1 + 2 * 3"), Ok(7))
  check.eq(calcula_expressao("(1 + 2) * 3"), Ok(9))
  check.eq(calcula_expressao("1 + 2 * 3 / 4"), Ok(2))
  check.eq(calcula_expressao("3 - 2 * 3 / 4"), Ok(2))
  check.eq(calcula_expressao("5 + 3 * 2 / (4 - 2)"), Ok(8))
  check.eq(calcula_expressao("(5 + 2) / (4 - 2) + 1"), Ok(4))
  check.eq(calcula_expressao("((5 + 2) / (4 - 2) + 1) * (5 * 3 / 3)"), Ok(20))
  check.eq(calcula_expressao("1 / 0"), Error(DivisaoPorZero))
  check.eq(calcula_expressao("1 + 2 * 3 /"), Error(ExpressaoInvalida))
  check.eq(calcula_expressao("1 + a"), Error(ExpressaoInvalida))
  check.eq(calcula_expressao("1 + 2 * 3 / (4 - 2"), Error(ParentesesInvalidos))
}