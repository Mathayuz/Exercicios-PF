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
// números inteiros (operandos) e operadores aritméticos como adição (+),
// subtração (-), multiplicação (*) e divisão (/). O programa deve
// ser capaz de lidar com expressões que contêm parênteses para
// definir a precedência dos operadores.
// O programa deve tratar expressões inválidas.

/// Os possíveis erros que podem ocorrer.
pub type Erros {
  // Erro de divisão por zero.
  DivisaoPorZero
  // Erro de expressão infixa inválida.
  ExpressaoInfixaInvalida
  // Erro de expressão pós-fixa inválida.
  ExpressaoPosFixaInvalida
  // Erro de parênteses inválidos.
  ParentesesInvalidos
}

/// Um operador aritmético.
pub type Operador {
  Adicao
  Subtracao
  Multiplicacao
  Divisao
}

/// Um símbolo de uma expressão na notação pós-fixa.
pub type SimboloPosFixa {
  // Número inteiro.
  OperandoPosFixa(numero: Int)
  // Operador aritmético.
  OperadorPosFixa(operador: Operador)
}

/// Um símbolo de uma expressão na notação infixa.
pub type SimboloInfixa {
  // Número inteiro.
  OperandoInfixa(numero: Int)
  // Operador aritmético.
  OperadorInfixa(operador: Operador)
  // Parêntese de abertura.
  ParenteseAbre
  // Parêntese de fechamento.
  ParenteseFecha
}

/// Realiza a avaliação de uma expressão na notação pós-fixa.
/// Onde cada simbolo da *lista* deve ser operando ou operador.
pub fn avalia_pos_fixa(lista: List(SimboloPosFixa)) -> Result(Int, Erros) {
  let resultado = list.fold(lista, [], avalia_pos_fixa_aux)
  case resultado {
    [OperandoPosFixa(resultado)] -> Ok(resultado)
    _ -> Error(ExpressaoPosFixaInvalida)
  }
}

pub fn avalia_pos_fixa_examples() {
  check.eq(avalia_pos_fixa([OperandoPosFixa(1)]), Ok(1))
  check.eq(avalia_pos_fixa([OperandoPosFixa(1), OperandoPosFixa(2), OperadorPosFixa(Adicao)]), Ok(3))
  check.eq(avalia_pos_fixa([OperandoPosFixa(1), OperandoPosFixa(2), OperadorPosFixa(Adicao), OperandoPosFixa(3), OperadorPosFixa(Multiplicacao)]), Ok(9))
  check.eq(avalia_pos_fixa([OperandoPosFixa(3), OperandoPosFixa(2), OperadorPosFixa(Subtracao), OperandoPosFixa(4), OperadorPosFixa(Multiplicacao), OperandoPosFixa(4), OperadorPosFixa(Divisao)]), Ok(1))
  check.eq(avalia_pos_fixa([OperandoPosFixa(9), OperandoPosFixa(4), OperandoPosFixa(8), OperandoPosFixa(6), OperadorPosFixa(Subtracao), OperadorPosFixa(Multiplicacao), OperadorPosFixa(Adicao)]), Ok(17))
  check.eq(avalia_pos_fixa([OperadorPosFixa(Adicao)]), Error(ExpressaoPosFixaInvalida))
  check.eq(avalia_pos_fixa([OperadorPosFixa(Adicao), OperandoPosFixa(3), OperandoPosFixa(4), OperadorPosFixa(Subtracao)]), Error(ExpressaoPosFixaInvalida))
}

pub fn avalia_pos_fixa_aux(pilha: List(SimboloPosFixa), simbolo: SimboloPosFixa) -> List(SimboloPosFixa) {
  case simbolo {
    OperandoPosFixa(numero) -> [OperandoPosFixa(numero), ..pilha]
    OperadorPosFixa(operador) -> [aplica_operador(pilha, simbolo), ..pilha_sem_2_primeiros(pilha)]
  }
}

pub fn pilha_sem_2_primeiros(pilha: List(SimboloPosFixa)) -> List(SimboloPosFixa) {
  case pilha {
    [_, _, ..resto] -> resto
    _ -> pilha
  }
}

pub fn aplica_operador(pilha: List(SimboloPosFixa), operador: SimboloPosFixa) -> SimboloPosFixa {
  case pilha {
    [OperandoPosFixa(operando2), OperandoPosFixa(operando1), ..] -> {
      case operador {
        OperadorPosFixa(Adicao) -> OperandoPosFixa(operando1 + operando2)
        OperadorPosFixa(Subtracao) -> OperandoPosFixa(operando1 - operando2)
        OperadorPosFixa(Multiplicacao) -> OperandoPosFixa(operando1 * operando2)
        OperadorPosFixa(Divisao) -> OperandoPosFixa(operando1 / operando2)
        OperandoPosFixa(_) -> operador
      }
    }
    _ -> operador
  }
}

/// Converte uma *expressão* infixa em uma expressão pós-fixa.
pub fn converte_infixa(expressao: List(SimboloInfixa)) -> Result(List(SimboloPosFixa), Erros) {
  todo
}

/// Converte uma *expressão* do tipo string em uma lista de símbolos.
pub fn converte_string(expressao: String) -> Result(List(SimboloInfixa), Erros) {
  todo
}

/// Função principal que recebe uma *expressão* infixa e calcula o valor da expressão.
pub fn calcula_expressao(expressao: String) -> Result(Int, Erros) {
  use expressao_convertida <- result.try(converte_string(expressao))
  use expressao_pos_fixa <- result.try(converte_infixa(expressao_convertida))
  avalia_pos_fixa(expressao_pos_fixa)
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
  check.eq(calcula_expressao("1 + 2 * 3 /"), Error(ExpressaoInfixaInvalida))
  check.eq(calcula_expressao("1 + a"), Error(ExpressaoInfixaInvalida))
  check.eq(calcula_expressao("1 + 2 * 3 / (4 - 2"), Error(ParentesesInvalidos))
}