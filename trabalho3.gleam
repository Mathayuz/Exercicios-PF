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
  check.eq(
    avalia_pos_fixa([
      OperandoPosFixa(1),
      OperandoPosFixa(2),
      OperadorPosFixa(Adicao),
    ]),
    Ok(3),
  )
  check.eq(
    avalia_pos_fixa([
      OperandoPosFixa(1),
      OperandoPosFixa(2),
      OperadorPosFixa(Adicao),
      OperandoPosFixa(3),
      OperadorPosFixa(Multiplicacao),
    ]),
    Ok(9),
  )
  check.eq(
    avalia_pos_fixa([
      OperandoPosFixa(3),
      OperandoPosFixa(2),
      OperadorPosFixa(Subtracao),
      OperandoPosFixa(4),
      OperadorPosFixa(Multiplicacao),
      OperandoPosFixa(4),
      OperadorPosFixa(Divisao),
    ]),
    Ok(1),
  )
  check.eq(
    avalia_pos_fixa([
      OperandoPosFixa(9),
      OperandoPosFixa(4),
      OperandoPosFixa(8),
      OperandoPosFixa(6),
      OperadorPosFixa(Subtracao),
      OperadorPosFixa(Multiplicacao),
      OperadorPosFixa(Adicao),
    ]),
    Ok(17),
  )
  check.eq(
    avalia_pos_fixa([OperadorPosFixa(Adicao)]),
    Error(ExpressaoPosFixaInvalida),
  )
  check.eq(
    avalia_pos_fixa([
      OperadorPosFixa(Adicao),
      OperandoPosFixa(3),
      OperandoPosFixa(4),
      OperadorPosFixa(Subtracao),
    ]),
    Error(ExpressaoPosFixaInvalida),
  )
}

// Função auxiliar que define o que será feito com um símbolo
// de uma expressão na notação pós-fixa, a partir da *pilha* e do *símbolo*.
pub fn avalia_pos_fixa_aux(
  pilha: List(SimboloPosFixa),
  simbolo: SimboloPosFixa,
) -> List(SimboloPosFixa) {
  case simbolo {
    OperandoPosFixa(numero) -> [OperandoPosFixa(numero), ..pilha]
    OperadorPosFixa(operador) -> [
      aplica_operador(pilha, simbolo),
      ..pilha_sem_2_primeiros(pilha)
    ]
  }
}

// Função auxiliar para remover os dois primeiros elementos de uma *pilha*.
pub fn pilha_sem_2_primeiros(
  pilha: List(SimboloPosFixa),
) -> List(SimboloPosFixa) {
  case pilha {
    [_, _, ..resto] -> resto
    _ -> pilha
  }
}

// Função auxiliar para aplicar um *operador* aos dois operandos
// desempilhados da *pilha*.
pub fn aplica_operador(
  pilha: List(SimboloPosFixa),
  operador: SimboloPosFixa,
) -> SimboloPosFixa {
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
pub fn converte_infixa(
  expressao: List(SimboloInfixa),
) -> Result(List(SimboloPosFixa), Erros) {
  use expressao_sem_erro <- result.try(verifica_erros_infixa(expressao))
  let tupla = list.fold(expressao_sem_erro, [[], []], converte_infixa_aux)
  let expressao_pos_fixa = remove_op_restantes(tupla)
  Ok(list.map(expressao_pos_fixa, converte_infixa_posfixa))
}

pub fn converte_infixa_examples() {
  check.eq(converte_infixa([OperandoInfixa(1)]), Ok([OperandoPosFixa(1)]))
  check.eq(
    converte_infixa([
      OperandoInfixa(1),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      OperadorInfixa(Subtracao),
      OperandoInfixa(4),
    ]),
    Ok([
      OperandoPosFixa(1),
      OperandoPosFixa(2),
      OperadorPosFixa(Adicao),
      OperandoPosFixa(4),
      OperadorPosFixa(Subtracao),
    ]),
  )
  check.eq(
    converte_infixa([
      ParenteseAbre,
      OperandoInfixa(1),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      ParenteseFecha,
      OperadorInfixa(Multiplicacao),
      OperandoInfixa(3),
    ]),
    Ok([
      OperandoPosFixa(1),
      OperandoPosFixa(2),
      OperadorPosFixa(Adicao),
      OperandoPosFixa(3),
      OperadorPosFixa(Multiplicacao),
    ]),
  )
  check.eq(
    converte_infixa([
      ParenteseAbre,
      OperandoInfixa(5),
      OperadorInfixa(Adicao),
      OperandoInfixa(3),
      ParenteseFecha,
      OperadorInfixa(Multiplicacao),
      ParenteseAbre,
      OperandoInfixa(8),
      OperadorInfixa(Subtracao),
      OperandoInfixa(4),
      ParenteseFecha,
      OperadorInfixa(Divisao),
      OperandoInfixa(2),
    ]),
    Ok([
      OperandoPosFixa(5),
      OperandoPosFixa(3),
      OperadorPosFixa(Adicao),
      OperandoPosFixa(8),
      OperandoPosFixa(4),
      OperadorPosFixa(Subtracao),
      OperadorPosFixa(Multiplicacao),
      OperandoPosFixa(2),
      OperadorPosFixa(Divisao),
    ]),
  )
  check.eq(
    converte_infixa([
      OperandoInfixa(1),
      OperadorInfixa(Divisao),
      OperandoInfixa(2),
      OperadorInfixa(Adicao),
    ]),
    Error(ExpressaoInfixaInvalida),
  )
  check.eq(
    converte_infixa([
      ParenteseAbre,
      OperandoInfixa(5),
      ParenteseAbre,
      OperadorInfixa(Adicao),
      OperandoInfixa(3),
      ParenteseFecha,
      OperadorInfixa(Multiplicacao),
      ParenteseAbre,
      OperandoInfixa(8),
      OperadorInfixa(Subtracao),
      OperandoInfixa(4),
      ParenteseFecha,
      OperadorInfixa(Divisao),
      OperandoInfixa(2),
    ]),
    Error(ParentesesInvalidos),
  )
}

// Função auxiliar para verificar se há algum erro semântico em uma *expressão* infixa.
pub fn verifica_erros_infixa(
  expressao: List(SimboloInfixa),
) -> Result(List(SimboloInfixa), Erros) {
  use expressao_p <- result.try(verifica_parenteses(expressao))
  use _ <- result.try(verifica_ordem(expressao_p))
  Ok(expressao)
}

// Função auxiliar para verificar se os parênteses de uma *expressão* são válidos.
pub fn verifica_parenteses(
  expressao: List(SimboloInfixa),
) -> Result(List(SimboloInfixa), Erros) {
  let parenteses = list.fold(expressao, 0, verifica_parenteses_aux)
  case parenteses {
    0 -> Ok(expressao)
    _ -> Error(ParentesesInvalidos)
  }
}

// Função auxiliar para verificar se os parênteses são válidos, utilizando
// um *contador* e verificando o *simbolo*.
pub fn verifica_parenteses_aux(contador: Int, simbolo: SimboloInfixa) -> Int {
  case simbolo {
    ParenteseAbre -> contador + 1
    ParenteseFecha -> contador - 1
    _ -> contador
  }
}

// Função auxiliar para verificar a ordem dos símbolos de uma *expressão*.
pub fn verifica_ordem(
  expressao: List(SimboloInfixa),
) -> Result(List(SimboloInfixa), Erros) {
  let sem_parenteses = list.filter(expressao, remove_parenteses)
  verifica_ordem_aux(sem_parenteses)
}

// Função auxiliar para verificar a ordem dos símbolos de uma *expressão*.
pub fn verifica_ordem_aux(
  expressao: List(SimboloInfixa),
) -> Result(List(SimboloInfixa), Erros) {
  case expressao {
    [OperandoInfixa(numero)] -> Ok([OperandoInfixa(numero)])
    [OperandoInfixa(_), OperadorInfixa(_), ..resto] -> verifica_ordem_aux(resto)
    _ -> Error(ExpressaoInfixaInvalida)
  }
}

// Funutenção auxiliar para remover os parênteses de uma *expressão*.
pub fn remove_parenteses(simbolo: SimboloInfixa) -> Bool {
  case simbolo {
    OperandoInfixa(_) -> True
    OperadorInfixa(_) -> True
    _ -> False
  }
}

// Função auxiliar para trocar os tipos de símbolos de uma *expressão*.
pub fn converte_infixa_posfixa(simbolo: SimboloInfixa) -> SimboloPosFixa {
  case simbolo {
    OperandoInfixa(numero) -> OperandoPosFixa(numero)
    OperadorInfixa(operador) -> OperadorPosFixa(operador)
    ParenteseAbre -> OperandoPosFixa(0)
    ParenteseFecha -> OperandoPosFixa(0)
  }
}

// Função auxiliar para remover os operadores restantes da pilha e adiciona-los
// à saída, utilizando uma *tupla*.
pub fn remove_op_restantes(
  tupla: List(List(SimboloInfixa)),
) -> List(SimboloInfixa) {
  case tupla {
    [saida, pilha] ->
      case pilha {
        [OperadorInfixa(operador), ..resto] ->
          remove_op_restantes([
            list.append(saida, [OperadorInfixa(operador)]),
            resto,
          ])
        _ -> saida
      }
    _ -> []
  }
}

// Função auxiliar para converter uma *expressão* infixa em uma expressão pós-fixa,
// utilizando uma *tupla* e verificando um *símbolo*.
pub fn converte_infixa_aux(
  tupla: List(List(SimboloInfixa)),
  simbolo: SimboloInfixa,
) -> List(List(SimboloInfixa)) {
  case tupla {
    [saida, pilha] ->
      case simbolo {
        OperandoInfixa(_) -> [list.append(saida, [simbolo]), pilha]
        OperadorInfixa(operador) -> operador_aux(saida, pilha, operador)
        ParenteseAbre -> [saida, [simbolo, ..pilha]]
        ParenteseFecha -> parentese_fecha_aux(saida, pilha)
      }
    _ -> tupla
  }
}

// Função auxiliar para realizar o algoritmo caso o símbolo seja um *operador*, utilizando
// a *saída* e a *pilha*.
pub fn operador_aux(
  saida: List(SimboloInfixa),
  pilha: List(SimboloInfixa),
  operador: Operador,
) -> List(List(SimboloInfixa)) {
  case pilha {
    [OperadorInfixa(operador_pilha), ..resto] ->
      case precedencia(operador_pilha) >= precedencia(operador) {
        True ->
          operador_aux(
            list.append(saida, [OperadorInfixa(operador_pilha)]),
            resto,
            operador,
          )
        False -> [saida, [OperadorInfixa(operador), ..pilha]]
      }
    _ -> [saida, [OperadorInfixa(operador), ..pilha]]
  }
}

// Função auxiliar para realizar o algoritmo caso o símbolo seja um parêntese de fechamento, utilizando
// a *saída* e a *pilha*.
pub fn parentese_fecha_aux(
  saida: List(SimboloInfixa),
  pilha: List(SimboloInfixa),
) -> List(List(SimboloInfixa)) {
  case pilha {
    [OperadorInfixa(operador), ..resto] ->
      parentese_fecha_aux(list.append(saida, [OperadorInfixa(operador)]), resto)
    [ParenteseAbre, ..] -> [saida, remove_primeiro(pilha)]
    _ -> [saida, pilha]
  }
}

// Função auxiliar para remover o primeiro elemento de uma lista de *símbolos*.
pub fn remove_primeiro(simbolos: List(SimboloInfixa)) -> List(SimboloInfixa) {
  case simbolos {
    [_, ..resto] -> resto
    _ -> simbolos
  }
}

// Função auxiliar para definir a precedência de um *operador*.
pub fn precedencia(operador: Operador) -> Int {
  case operador {
    Adicao -> 1
    Subtracao -> 1
    Multiplicacao -> 2
    Divisao -> 2
  }
}

/// Converte uma *expressão* do tipo string em uma lista de símbolos.
pub fn converte_string(expressao: String) -> Result(List(SimboloInfixa), Erros) {
  let simbolos = string.split(expressao, "")
  let simbolos_sem_espaco = remove_espacos(simbolos)
  converte_string_infixa(simbolos_sem_espaco)
}

pub fn converte_string_examples() {
  check.eq(converte_string("1"), Ok([OperandoInfixa(1)]))
  check.eq(
    converte_string("1+2"),
    Ok([OperandoInfixa(1), OperadorInfixa(Adicao), OperandoInfixa(2)]),
  )
  check.eq(
    converte_string("1+2 * 3"),
    Ok([
      OperandoInfixa(1),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      OperadorInfixa(Multiplicacao),
      OperandoInfixa(3),
    ]),
  )
  check.eq(
    converte_string("(1 + 2) * 3"),
    Ok([
      ParenteseAbre,
      OperandoInfixa(1),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      ParenteseFecha,
      OperadorInfixa(Multiplicacao),
      OperandoInfixa(3),
    ]),
  )
  check.eq(
    converte_string("1 + 2 * 3 / 4"),
    Ok([
      OperandoInfixa(1),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      OperadorInfixa(Multiplicacao),
      OperandoInfixa(3),
      OperadorInfixa(Divisao),
      OperandoInfixa(4),
    ]),
  )
  check.eq(
    converte_string("-5 + 3 * 2 / (4 - 2)"),
    Ok([
      OperandoInfixa(-5),
      OperadorInfixa(Adicao),
      OperandoInfixa(3),
      OperadorInfixa(Multiplicacao),
      OperandoInfixa(2),
      OperadorInfixa(Divisao),
      ParenteseAbre,
      OperandoInfixa(4),
      OperadorInfixa(Subtracao),
      OperandoInfixa(2),
      ParenteseFecha,
    ]),
  )
  check.eq(
    converte_string("(5 + 2) / (4 - 2) + 1"),
    Ok([
      ParenteseAbre,
      OperandoInfixa(5),
      OperadorInfixa(Adicao),
      OperandoInfixa(2),
      ParenteseFecha,
      OperadorInfixa(Divisao),
      ParenteseAbre,
      OperandoInfixa(4),
      OperadorInfixa(Subtracao),
      OperandoInfixa(2),
      ParenteseFecha,
      OperadorInfixa(Adicao),
      OperandoInfixa(1),
    ]),
  )
}

// Função auxiliar par remover os espaços de uma lista de *símbolos*.
pub fn remove_espacos(simbolos: List(String)) -> List(SimboloInfixa) {
  list.filter(simbolos, fn(s) {
    case s {
      " " -> False
      _ -> True
    }
  })
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
  check.eq(calcula_expressao("5 + 3 * 2 / (4 - 2)"), Ok(8))
  check.eq(calcula_expressao("(5 + 2) / (4 - 2) + 1"), Ok(4))
  check.eq(calcula_expressao("((5 + 2) / (4 - 2) + 1) * (5 * 3 / 3)"), Ok(20))
  check.eq(calcula_expressao("1 + 2 * 3 /"), Error(ExpressaoInfixaInvalida))
  check.eq(calcula_expressao("1 + a"), Error(ExpressaoInfixaInvalida))
  check.eq(calcula_expressao("1 + 2 * 3 / (4 - 2"), Error(ParentesesInvalidos))
}
