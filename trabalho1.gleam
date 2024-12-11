// Matheus Cenerini Jacomini RA: 134700, Caetano Vendrame Mantovani RA: 135846.

import gleam/int
import gleam/order
import gleam/string
import sgleam/check

// Desenvolver um sistema para gerar a classificação dos times participantes
// de um campeonato de futebol com base nos resultados de suas partidas.
// O sistema de pontuação dos jogos é dado por: uma vitória vale 3 pontos,
// um empate vale 1 ponto e uma derrota vale 0 pontos.
// Os critérios para desempate entre os times são: quantidade de pontos, número de vitórias,
// saldo de gols e ordem alfabética consecutivamente.

// A classificação dos times deve ser ter o formato de uma tabela, onde estarão 
// dispostos todos os times que participaram de um jogo do campeonato de maneira ordenada.
// O time com melhor desempenho deve estar no topo da tabela, e os times subsequentes devem
// ser colocados em suas respectivas posições na tabela, seguindo os critérios de desempate.

pub type Resultado {
  Resultado(
    anfitriao: String,
    gols_anfitriao: Int,
    visitante: String,
    gols_visitante: Int,
  )
}

/// O desempenho de um time, com o nome do time, a quantidade de pontos,
/// a quantidade de vitórias e o saldo de gols.
pub type Desempenho {
  Desempenho(time: String, pontos: Int, vitorias: Int, saldo_gols: Int)
}

/// Os possíveis erros que podem acontecer ao montar a classificação dos times.
pub type Erros {
  // Gols do anfitrião não é um número.
  NaoEhNumeroAnfitriao
  // Gols do visitante não é um número.
  NaoEhNumeroVisitante
  // Gols do anfitrião e do visitante não são números.
  NaoEhNumeroAnfitriaoVisitante
  // Gols do anfitrião é um número inválido.
  NumeroInvalidoAnfitriao
  // Gols do visitante é um número inválido.
  NumeroInvalidoVisitante
  // Gols do anfitrião e do visitante são números inválidos.
  NumeroInvalidoAnfitriaoVisitante
  // Quantidade de campos de um resultado inválida.
  QuantidadeCamposInvalida
  // Mesmo time dos dois lados de um resultado.
  MesmoTime
}

/// Converte uma lista de *resultados* em uma lista do tipo Resultado se ela for válida.
/// Caso não seja válida, produz um erro.
pub fn converte_resultados(
  resultados: List(String),
) -> Result(List(Resultado), Erros) {
  case resultados {
    [] -> Ok([])
    [resultado, ..resto] ->
      case converte_resultado(resultado), converte_resultados(resto) {
        Ok(resultado), Ok(resto) -> Ok([resultado, ..resto])
        Error(erro), _ -> Error(erro)
        _, Error(erro) -> Error(erro)
      }
  }
}

pub fn converte_resultados_examples() {
  check.eq(converte_resultados([]), Ok([]))
  check.eq(
    converte_resultados(["Palmeiras 3 Corinthians 0"]),
    Ok([Resultado("Palmeiras", 3, "Corinthians", 0)]),
  )
  check.eq(
    converte_resultados([
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1",
    ]),
    Ok([
      Resultado("Palmeiras", 3, "Corinthians", 0),
      Resultado("Corinthians", 1, "Palmeiras", 1),
    ]),
  )
  check.eq(
    converte_resultados([
      "Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
      "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2",
    ]),
    Ok([
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
    ]),
  )
  check.eq(
    converte_resultados(["Palmeiras 3 Corinthians 0 0"]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    converte_resultados(["Palmeiras 3 Corinthians"]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    converte_resultados(["Palmeiras a Corinthians 0"]),
    Error(NaoEhNumeroAnfitriao),
  )
  check.eq(
    converte_resultados(["Palmeiras 3 Corinthians a"]),
    Error(NaoEhNumeroVisitante),
  )
  check.eq(
    converte_resultados(["Palmeiras a Corinthians b"]),
    Error(NaoEhNumeroAnfitriaoVisitante),
  )
  check.eq(
    converte_resultados(["Palmeiras -1 Corinthians 0"]),
    Error(NumeroInvalidoAnfitriao),
  )
  check.eq(
    converte_resultados(["Palmeiras 3 Corinthians -1"]),
    Error(NumeroInvalidoVisitante),
  )
  check.eq(
    converte_resultados(["Palmeiras -3 Corinthians -1"]),
    Error(NumeroInvalidoAnfitriaoVisitante),
  )
  check.eq(converte_resultados(["Palmeiras 3 Palmeiras 0"]), Error(MesmoTime))
  check.eq(
    converte_resultados([
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1",
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Corinthians 1",
    ]),
    Error(MesmoTime),
  )
}

/// Converte um *resultado* no formato "anfitrião gols visitante gols"
/// para o tipo Resultado se a entrada for válida.
/// Caso não seja válida, produz um erro.
pub fn converte_resultado(resultado: String) -> Result(Resultado, Erros) {
  case string.split(resultado, " ") {
    [anfitriao, gols1, visitante, gols2] ->
      case valida_gols(gols1, gols2) {
        Ok([gols1, gols2]) ->
          case anfitriao == visitante {
            True -> Error(MesmoTime)
            False -> Ok(Resultado(anfitriao, gols1, visitante, gols2))
          }
        Ok(_) -> Error(QuantidadeCamposInvalida)
        Error(erro) -> Error(erro)
      }
    _ -> Error(QuantidadeCamposInvalida)
  }
}

pub fn converte_resultado_examples() {
  check.eq(
    converte_resultado("Palmeiras 3 Corinthians 0"),
    Ok(Resultado("Palmeiras", 3, "Corinthians", 0)),
  )
  check.eq(
    converte_resultado("Palmeiras 3 Corinthians"),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    converte_resultado("Palmeiras 3 Corinthians 0 0"),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    converte_resultado("Palmeiras a Corinthians 0"),
    Error(NaoEhNumeroAnfitriao),
  )
  check.eq(
    converte_resultado("Palmeiras 3 Corinthians a"),
    Error(NaoEhNumeroVisitante),
  )
  check.eq(
    converte_resultado("Palmeiras a Corinthians b"),
    Error(NaoEhNumeroAnfitriaoVisitante),
  )
  check.eq(
    converte_resultado("Palmeiras -1 Corinthians 0"),
    Error(NumeroInvalidoAnfitriao),
  )
  check.eq(
    converte_resultado("Palmeiras 3 Corinthians -1"),
    Error(NumeroInvalidoVisitante),
  )
  check.eq(
    converte_resultado("Palmeiras -3 Corinthians -1"),
    Error(NumeroInvalidoAnfitriaoVisitante),
  )
  check.eq(converte_resultado("Palmeiras 3 Palmeiras 0"), Error(MesmoTime))
}

/// Função auxiliar para validar os *gols1* de um time e os *gols2* de outro time.
pub fn valida_gols(gols1: String, gols2: String) -> Result(List(Int), Erros) {
  case int.parse(gols1), int.parse(gols2) {
    Ok(gols1), Ok(gols2) ->
      case gols1 > 0 && gols2 > 0 {
        True -> Ok([gols1, gols2])
        False ->
          case gols1 < 0 && gols2 < 0 {
            True -> Error(NumeroInvalidoAnfitriaoVisitante)
            False ->
              case gols1 < 0 && gols2 >= 0 {
                True -> Error(NumeroInvalidoAnfitriao)
                False ->
                  case gols2 < 0 && gols1 >= 0 {
                    True -> Error(NumeroInvalidoVisitante)
                    False -> Ok([gols1, gols2])
                  }
              }
          }
      }
    Error(Nil), Ok(_) -> Error(NaoEhNumeroAnfitriao)
    Ok(_), Error(Nil) -> Error(NaoEhNumeroVisitante)
    Error(Nil), Error(Nil) -> Error(NaoEhNumeroAnfitriaoVisitante)
  }
}

/// Produz uma lista com os nomes de todos os times que estão em uma *lista* de Resultado.
pub fn lista_times(lista: List(Resultado)) -> List(String) {
  case lista {
    [] -> []
    [Resultado(anfitriao, _, visitante, _), ..resto] ->
      case
        verifica_lista_times(anfitriao, lista_times(resto)),
        verifica_lista_times(visitante, lista_times(resto))
      {
        False, False -> [anfitriao, visitante, ..lista_times(resto)]
        False, True -> [anfitriao, ..lista_times(resto)]
        True, False -> [visitante, ..lista_times(resto)]
        True, True -> lista_times(resto)
      }
  }
}

pub fn lista_times_examples() {
  check.eq(lista_times([]), [])
  check.eq(lista_times([Resultado("Palmeiras", 3, "Corinthians", 0)]), [
    "Palmeiras", "Corinthians",
  ])
  check.eq(
    lista_times([
      Resultado("Palmeiras", 3, "Corinthians", 0),
      Resultado("Corinthians", 1, "Palmeiras", 1),
    ]),
    ["Corinthians", "Palmeiras"],
  )
  check.eq(
    lista_times([
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
    ]),
    ["Palmeiras", "Sao-Paulo", "Atletico-MG", "Flamengo"],
  )
}

/// Devolve True se um *time* está em uma *lista* de times. Devolve False caso contrário.
pub fn verifica_lista_times(time: String, lista: List(String)) -> Bool {
  case lista {
    [] -> False
    [primeiro, ..resto] -> primeiro == time || verifica_lista_times(time, resto)
  }
}

pub fn verifica_lista_times_examples() {
  check.eq(verifica_lista_times("Palmeiras", []), False)
  check.eq(
    verifica_lista_times("Palmeiras", ["Palmeiras", "Corinthians"]),
    True,
  )
  check.eq(
    verifica_lista_times("Palmeiras", ["Corinthians", "Sao-Paulo"]),
    False,
  )
  check.eq(
    verifica_lista_times("Palmeiras", ["Corinthians", "Palmeiras"]),
    True,
  )
}

/// Devolve True se um *time* está em um *resultado*. Devolve False caso contrário.
pub fn verifica_time(time: String, resultado: Resultado) -> Bool {
  resultado.anfitriao == time || resultado.visitante == time
}

pub fn verifica_time_examples() {
  check.eq(
    verifica_time("Palmeiras", Resultado("Palmeiras", 3, "Corinthians", 0)),
    True,
  )
  check.eq(
    verifica_time("Corinthians", Resultado("Palmeiras", 3, "Corinthians", 0)),
    True,
  )
  check.eq(
    verifica_time("Corinthians", Resultado("Sao-Paulo", 3, "Flamengo", 0)),
    False,
  )
}

/// Calcula todos os desempenhos de um *time* baseado nos *resultados* de seus jogos e
/// produz uma lista com esses desempenhos.
pub fn calcula_desempenho_lista(
  time: String,
  resultados: List(Resultado),
) -> List(Desempenho) {
  case resultados {
    [] -> [Desempenho(time, 0, 0, 0)]
    [primeiro, ..resto] -> [
      calcula_desempenho(time, primeiro),
      ..calcula_desempenho_lista(time, resto)
    ]
  }
}

pub fn calcula_desempenho_lista_examples() {
  check.eq(calcula_desempenho_lista("Palmeiras", []), [
    Desempenho("Palmeiras", 0, 0, 0),
  ])
  check.eq(
    calcula_desempenho_lista("Palmeiras", [
      Resultado("Palmeiras", 3, "Corinthians", 0),
    ]),
    [Desempenho("Palmeiras", 3, 1, 3), Desempenho("Palmeiras", 0, 0, 0)],
  )
  check.eq(
    calcula_desempenho_lista("Palmeiras", [
      Resultado("Palmeiras", 3, "Corinthians", 0),
      Resultado("Corinthians", 1, "Palmeiras", 1),
    ]),
    [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Palmeiras", 1, 0, 0),
      Desempenho("Palmeiras", 0, 0, 0),
    ],
  )
  check.eq(
    calcula_desempenho_lista("Sao-Paulo", [
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
    ]),
    [
      Desempenho("Sao-Paulo", 0, 0, -1),
      Desempenho("Sao-Paulo", 0, 0, 0),
      Desempenho("Sao-Paulo", 1, 0, 0),
      Desempenho("Sao-Paulo", 0, 0, 0),
      Desempenho("Sao-Paulo", 0, 0, 0),
    ],
  )
}

/// Calcula o desempenho de um *time* baseado em um *resultado*.
pub fn calcula_desempenho(time: String, resultado: Resultado) -> Desempenho {
  case verifica_time(time, resultado) {
    True ->
      case time == resultado.anfitriao {
        True ->
          calcula_desempenho_aux(
            time,
            resultado.gols_anfitriao,
            resultado.gols_visitante,
          )
        False ->
          calcula_desempenho_aux(
            time,
            resultado.gols_visitante,
            resultado.gols_anfitriao,
          )
      }
    False -> Desempenho(time, 0, 0, 0)
  }
}

pub fn calcula_desempenho_examples() {
  check.eq(
    calcula_desempenho("Palmeiras", Resultado("Palmeiras", 3, "Corinthians", 0)),
    Desempenho("Palmeiras", 3, 1, 3),
  )
  check.eq(
    calcula_desempenho("Palmeiras", Resultado("Palmeiras", 0, "Corinthians", 3)),
    Desempenho("Palmeiras", 0, 0, -3),
  )
  check.eq(
    calcula_desempenho("Palmeiras", Resultado("Palmeiras", 1, "Corinthians", 1)),
    Desempenho("Palmeiras", 1, 0, 0),
  )
  check.eq(
    calcula_desempenho(
      "Corinthians",
      Resultado("Palmeiras", 0, "Corinthians", 3),
    ),
    Desempenho("Corinthians", 3, 1, 3),
  )
  check.eq(
    calcula_desempenho(
      "Corinthians",
      Resultado("Palmeiras", 3, "Corinthians", 0),
    ),
    Desempenho("Corinthians", 0, 0, -3),
  )
  check.eq(
    calcula_desempenho(
      "Corinthians",
      Resultado("Palmeiras", 1, "Corinthians", 1),
    ),
    Desempenho("Corinthians", 1, 0, 0),
  )
}

// Calcula o desempenho de um *time* com base nos *gols1* marcados por ele e nos
// *gols2* marcados pelo seu adversário
pub fn calcula_desempenho_aux(
  time: String,
  gols1: Int,
  gols2: Int,
) -> Desempenho {
  case gols1 > gols2 {
    True -> Desempenho(time, 3, 1, gols1 - gols2)
    False ->
      case gols1 < gols2 {
        True -> Desempenho(time, 0, 0, gols1 - gols2)
        False -> Desempenho(time, 1, 0, 0)
      }
  }
}

/// Calcula o desempenho total de um *time* a partir de uma lista com todos seus *desempenhos*.
pub fn calcula_desempenho_total(
  time: String,
  desempenhos: List(Desempenho),
) -> Desempenho {
  case desempenhos {
    [] -> Desempenho(time, 0, 0, 0)
    [primeiro, ..resto] ->
      case primeiro {
        Desempenho(time, pontos, vitorias, saldo_gols) ->
          Desempenho(
            time,
            pontos + calcula_desempenho_total(time, resto).pontos,
            vitorias + calcula_desempenho_total(time, resto).vitorias,
            saldo_gols + calcula_desempenho_total(time, resto).saldo_gols,
          )
      }
  }
}

pub fn calcula_desempenho_total_examples() {
  check.eq(
    calcula_desempenho_total("Palmeiras", []),
    Desempenho("Palmeiras", 0, 0, 0),
  )
  check.eq(
    calcula_desempenho_total("Palmeiras", [Desempenho("Palmeiras", 3, 1, 3)]),
    Desempenho("Palmeiras", 3, 1, 3),
  )
  check.eq(
    calcula_desempenho_total("Palmeiras", [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Palmeiras", 1, 0, 0),
    ]),
    Desempenho("Palmeiras", 4, 1, 3),
  )
  check.eq(
    calcula_desempenho_total("Palmeiras", [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Palmeiras", 1, 0, 0),
      Desempenho("Palmeiras", 0, 0, -4),
    ]),
    Desempenho("Palmeiras", 4, 1, -1),
  )
  check.eq(
    calcula_desempenho_total("Sao-Paulo", [
      Desempenho("Sao-Paulo", 0, 0, -1),
      Desempenho("Sao-Paulo", 0, 0, 0),
      Desempenho("Sao-Paulo", 1, 0, 0),
      Desempenho("Sao-Paulo", 0, 0, 0),
    ]),
    Desempenho("Sao-Paulo", 1, 0, -1),
  )
}

/// Produz uma lista com os desempenhos de todos os times a partir de uma lista com os
/// nomes dos *times* e de uma lista com os *resultados* desses times.
pub fn lista_desempenhos(
  times: List(String),
  resultados: List(Resultado),
) -> List(Desempenho) {
  case times {
    [] -> []
    [time, ..resto] -> [
      calcula_desempenho_total(time, calcula_desempenho_lista(time, resultados)),
      ..lista_desempenhos(resto, resultados)
    ]
  }
}

pub fn lista_desempenhos_examples() {
  check.eq(lista_desempenhos([], []), [])
  check.eq(
    lista_desempenhos(["Palmeiras", "Corinthians"], [
      Resultado("Palmeiras", 3, "Corinthians", 0),
    ]),
    [Desempenho("Palmeiras", 3, 1, 3), Desempenho("Corinthians", 0, 0, -3)],
  )
  check.eq(
    lista_desempenhos(["Palmeiras", "Corinthians"], [
      Resultado("Palmeiras", 3, "Corinthians", 0),
      Resultado("Corinthians", 1, "Palmeiras", 1),
    ]),
    [Desempenho("Palmeiras", 4, 1, 3), Desempenho("Corinthians", 1, 0, -3)],
  )
  check.eq(
    lista_desempenhos(["Sao-Paulo", "Atletico-MG", "Flamengo", "Palmeiras"], [
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
    ]),
    [
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ],
  )
}

/// Ordena os times baseado em seus *desempenhos*, do melhor para o pior.
pub fn ordena_times(desempenhos: List(Desempenho)) -> List(Desempenho) {
  case desempenhos {
    [] -> []
    [primeiro, ..resto] -> [
      encontra_melhor_desempenho(primeiro, resto),
      ..ordena_times(remove_desempenho(
        encontra_melhor_desempenho(primeiro, resto),
        desempenhos,
      ))
    ]
  }
}

pub fn ordena_times_examples() {
  check.eq(ordena_times([]), [])
  check.eq(ordena_times([Desempenho("Palmeiras", 3, 1, 3)]), [
    Desempenho("Palmeiras", 3, 1, 3),
  ])
  check.eq(
    ordena_times([
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    [Desempenho("Palmeiras", 3, 1, 3), Desempenho("Corinthians", 0, 0, -3)],
  )
  check.eq(
    ordena_times([
      Desempenho("Corinthians", 0, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    [Desempenho("Palmeiras", 4, 1, 3), Desempenho("Corinthians", 0, 0, -3)],
  )
  check.eq(
    ordena_times([
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    [
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
      Desempenho("Sao-Paulo", 1, 0, -1),
    ],
  )
  check.eq(
    ordena_times([
      Desempenho("Sao-Paulo", 9, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 9, 3, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    [
      Desempenho("Flamengo", 9, 3, 2),
      Desempenho("Sao-Paulo", 9, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
    ],
  )
  check.eq(
    ordena_times([
      Desempenho("Sao-Paulo", 6, 3, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 3, 3),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    [
      Desempenho("Flamengo", 6, 3, 3),
      Desempenho("Sao-Paulo", 6, 3, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
    ],
  )
  check.eq(
    ordena_times([
      Desempenho("Sao-Paulo", 6, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    [
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Sao-Paulo", 6, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
    ],
  )
}

/// Encontra o melhor desempenho entre o *desempenho1* e o *desempenho2*.
pub fn compara_desempenhos(
  desempenho1: Desempenho,
  desempenho2: Desempenho,
) -> Desempenho {
  case
    desempenho1.pontos > desempenho2.pontos
    || desempenho1.pontos == desempenho2.pontos
    && {
      desempenho1.vitorias > desempenho2.vitorias
      || desempenho1.vitorias == desempenho2.vitorias
      && {
        desempenho1.saldo_gols > desempenho2.saldo_gols
        || desempenho1.saldo_gols == desempenho2.saldo_gols
        && string.compare(desempenho1.time, desempenho2.time) == order.Lt
      }
    }
  {
    True -> desempenho1
    False -> desempenho2
  }
}

pub fn compara_desempenhos_examples() {
  check.eq(
    compara_desempenhos(
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ),
    Desempenho("Palmeiras", 3, 1, 3),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Corinthians", 0, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ),
    Desempenho("Palmeiras", 4, 1, 3),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
    ),
    Desempenho("Atletico-MG", 3, 1, 0),
  )
  check.eq(
    compara_desempenhos(
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ),
    Desempenho("Flamengo", 6, 2, 2),
  )
}

/// Encontra e devolve o melhor desempenho de uma lista de *desempenhos*.
/// Caso a lista seja vazia, devolve o *primeiro* desempenho.
pub fn encontra_melhor_desempenho(
  primeiro: Desempenho,
  resto: List(Desempenho),
) -> Desempenho {
  case resto {
    [] -> primeiro
    [proximo, ..outros] ->
      compara_desempenhos(primeiro, encontra_melhor_desempenho(proximo, outros))
  }
}

pub fn encontra_melhor_desempenho_examples() {
  check.eq(
    encontra_melhor_desempenho(Desempenho("Palmeiras", 3, 1, 3), []),
    Desempenho("Palmeiras", 3, 1, 3),
  )

  check.eq(
    encontra_melhor_desempenho(Desempenho("Palmeiras", 3, 1, 3), [
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    Desempenho("Palmeiras", 3, 1, 3),
  )

  check.eq(
    encontra_melhor_desempenho(Desempenho("Corinthians", 1, 0, -3), [
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    Desempenho("Palmeiras", 4, 1, 3),
  )

  check.eq(
    encontra_melhor_desempenho(Desempenho("Sao-Paulo", 1, 0, -1), [
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    Desempenho("Flamengo", 6, 2, 2),
  )
}

/// Remove um *desempenho* de uma lista de *desempenhos*.
pub fn remove_desempenho(
  desempenho: Desempenho,
  desempenhos: List(Desempenho),
) -> List(Desempenho) {
  case desempenhos {
    [] -> []
    [primeiro, ..resto] ->
      case primeiro == desempenho {
        True -> resto
        False -> [primeiro, ..remove_desempenho(desempenho, resto)]
      }
  }
}

pub fn remove_desempenho_examples() {
  check.eq(remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), []), [])
  check.eq(
    remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), [
      Desempenho("Palmeiras", 3, 1, 3),
    ]),
    [],
  )
  check.eq(
    remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    [Desempenho("Corinthians", 0, 0, -3)],
  )
  check.eq(
    remove_desempenho(Desempenho("Corinthians", 0, 0, -3), [
      Desempenho("Corinthians", 0, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    [Desempenho("Palmeiras", 4, 1, 3)],
  )
  check.eq(
    remove_desempenho(Desempenho("Sao-Paulo", 1, 0, -1), [
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    [
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ],
  )
}

/// Converte uma lista de *desempenhos* do tipo Desempenho
/// em uma lista no formato "time pontos vitórias saldo_de_gols".
pub fn desempenhos_para_strings(desempenhos: List(Desempenho)) -> List(String) {
  case desempenhos {
    [] -> []
    [primeiro, ..resto] -> [
      string.join(
        [
          primeiro.time,
          int.to_string(primeiro.pontos),
          int.to_string(primeiro.vitorias),
          int.to_string(primeiro.saldo_gols),
        ],
        with: " ",
      ),
      ..desempenhos_para_strings(resto)
    ]
  }
}

pub fn desempenhos_para_strings_examples() {
  check.eq(desempenhos_para_strings([]), [])
  check.eq(desempenhos_para_strings([Desempenho("Palmeiras", 3, 1, 3)]), [
    "Palmeiras 3 1 3",
  ])
  check.eq(
    desempenhos_para_strings([
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    ["Palmeiras 3 1 3", "Corinthians 0 0 -3"],
  )
  check.eq(
    desempenhos_para_strings([
      Desempenho("Palmeiras", 4, 1, 3),
      Desempenho("Corinthians", 1, 0, -3),
    ]),
    ["Palmeiras 4 1 3", "Corinthians 1 0 -3"],
  )
  check.eq(
    desempenhos_para_strings([
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
      Desempenho("Sao-Paulo", 1, 0, -1),
    ]),
    [
      "Flamengo 6 2 2", "Atletico-MG 3 1 0", "Palmeiras 1 0 -1",
      "Sao-Paulo 1 0 -1",
    ],
  )
}

/// Monta a classificação dos times a partir dos *resultados* de seus jogos.
pub fn monta_classificacao(
  resultados: List(String),
) -> Result(List(String), Erros) {
  case converte_resultados(resultados) {
    Ok(resultados) ->
      case lista_desempenhos(lista_times(resultados), resultados) {
        desempenhos -> Ok(desempenhos_para_strings(ordena_times(desempenhos)))
      }
    Error(erro) -> Error(erro)
  }
}

pub fn monta_classificacao_examples() {
  check.eq(monta_classificacao([]), Ok([]))
  check.eq(
    monta_classificacao([
      "Palmeiras 1 Sao-Paulo 0", "Palmeiras 3 Corinthians 0 0",
    ]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    monta_classificacao(["Santos 2 Críciuma 4", "Palmeiras 3 Corinthians"]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras a Corinthians 0",
    ]),
    Error(NaoEhNumeroAnfitriao),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras 3 Corinthians a",
    ]),
    Error(NaoEhNumeroVisitante),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras a Corinthians b",
    ]),
    Error(NaoEhNumeroAnfitriaoVisitante),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras -1 Corinthians 0",
    ]),
    Error(NumeroInvalidoAnfitriao),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras 3 Corinthians -1",
    ]),
    Error(NumeroInvalidoVisitante),
  )
  check.eq(
    monta_classificacao([
      "Maringá-FC 2 Flamengo 0", "Palmeiras -3 Corinthians -1",
      "Palmeiras 3 Corinthians 0 0",
    ]),
    Error(NumeroInvalidoAnfitriaoVisitante),
  )
  check.eq(monta_classificacao(["Palmeiras 3 Palmeiras 0"]), Error(MesmoTime))
  check.eq(
    monta_classificacao([
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1",
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Corinthians 1",
    ]),
    Error(MesmoTime),
  )
  check.eq(
    monta_classificacao(["Palmeiras 3 Corinthians 0"]),
    Ok(["Palmeiras 3 1 3", "Corinthians 0 0 -3"]),
  )
  check.eq(
    monta_classificacao([
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1",
    ]),
    Ok(["Palmeiras 4 1 3", "Corinthians 1 0 -3"]),
  )
  check.eq(
    monta_classificacao([
      "Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
      "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2",
    ]),
    Ok([
      "Flamengo 6 2 2", "Atletico-MG 3 1 0", "Palmeiras 1 0 -1",
      "Sao-Paulo 1 0 -1",
    ]),
  )

  check.eq(
    monta_classificacao([
      "Sao-Paulo 2 Flamengo 2", "Palmeiras 3 Atletico-MG 1",
      "Atletico-MG 0 Sao-Paulo 1", "Flamengo 1 Palmeiras 1",
      "Sao-Paulo 3 Palmeiras 0", "Flamengo 2 Atletico-MG 2",
      "Atletico-MG 1 Sao-Paulo 1", "Palmeiras 2 Flamengo 2",
    ]),
    Ok([
      "Sao-Paulo 8 2 4", "Palmeiras 5 1 -1", "Flamengo 4 0 0",
      "Atletico-MG 2 0 -3",
    ]),
  )
}
