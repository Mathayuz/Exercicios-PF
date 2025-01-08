// Matheus Cenerini Jacomini RA: 134700, Caetano Vendrame Mantovani RA: 135846.

import gleam/int
import gleam/order
import gleam/string
import gleam/list
import gleam/result
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
pub fn converte_resultados(resultados: List(String)) -> Result(List(Resultado), Erros) {
  use _ <- result.try(list.try_each(resultados, converte_resultado))
  Ok(result.values(list.map(resultados, converte_resultado)))
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
    converte_resultados([
      "Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1",
      "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2",
      "Santos 2 America-MG 4", "Maringa-FC 7 Flamengo 1"
    ]),
    Ok([
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
      Resultado("Santos", 2, "America-MG", 4),
      Resultado("Maringa-FC", 7, "Flamengo", 1),
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
  check.eq(
    converte_resultados([
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1",
      "Palmeiras 3 Corinthians 0", "Corinthians 1 Corinthians 1",
      "Palmeiras 1 Corinthians 2", "Santos 1 Corinthians 4",
    ]),
    Error(MesmoTime),
  )
}

/// Converte um *resultado* no formato "anfitrião gols visitante gols"
/// para o tipo Resultado se a entrada for válida.
/// Caso não seja válida, produz um erro.
pub fn converte_resultado(resultado: String) -> Result(Resultado, Erros) {
  case string.split(resultado, " ") {
    [anfitriao, gols1, visitante, gols2] -> case anfitriao == visitante {
      True -> Error(MesmoTime)
      False -> case int.parse(gols1), int.parse(gols2) {
        Ok(gols1), Ok(gols2) -> case gols1 < 0 && gols2 < 0 {
          True -> Error(NumeroInvalidoAnfitriaoVisitante)
          False -> case gols1 < 0 && gols2 >= 0 {
            True -> Error(NumeroInvalidoAnfitriao)
            False -> case gols2 < 0 && gols1 >= 0 {
              True -> Error(NumeroInvalidoVisitante)
              False -> Ok(Resultado(anfitriao, gols1, visitante, gols2))
            }
          }
        }
        Error(Nil), Ok(_) -> Error(NaoEhNumeroAnfitriao)
        Ok(_), Error(Nil) -> Error(NaoEhNumeroVisitante)
        Error(Nil), Error(Nil) -> Error(NaoEhNumeroAnfitriaoVisitante)
      }
    }
    _ -> Error(QuantidadeCamposInvalida)
  }
}

/// Produz uma lista com os nomes de todos os times que estão em uma *lista* de Resultado.
pub fn lista_times(resultados: List(Resultado)) -> List(String) {
  resultados
  |> list.map(nomes_times_resultado)
  |> list.flatten
  |> list.unique
}

// Auxiliar para encontrar os nomes dos times anfitriao e visitante de um *resultado*.
pub fn nomes_times_resultado(resultado: Resultado) -> List(String) {
  [resultado.anfitriao, resultado.visitante]
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
    ["Palmeiras", "Corinthians"],
  )
  check.eq(
    lista_times([
      Resultado("Sao-Paulo", 1, "Atletico-MG", 2),
      Resultado("Flamengo", 2, "Palmeiras", 1),
      Resultado("Palmeiras", 0, "Sao-Paulo", 0),
      Resultado("Atletico-MG", 1, "Flamengo", 2),
    ]),
    ["Sao-Paulo", "Atletico-MG", "Flamengo", "Palmeiras"],
  )
}

/// Calcula todos os desempenhos de um *time* baseado nos *resultados* de seus jogos e
/// produz uma lista com esses desempenhos.
pub fn calcula_desempenho_lista(
  time: String,
  resultados: List(Resultado),
) -> List(Desempenho) {
  list.map(resultados, calcula_desempenho(time, _))
}

pub fn calcula_desempenho_lista_examples() {
  check.eq(calcula_desempenho_lista("Palmeiras", []), [])
  check.eq(
    calcula_desempenho_lista("Palmeiras", [
      Resultado("Palmeiras", 3, "Corinthians", 0),
    ]),
    [Desempenho("Palmeiras", 3, 1, 3)],
  )
  check.eq(
    calcula_desempenho_lista("Palmeiras", [
      Resultado("Palmeiras", 3, "Corinthians", 0),
      Resultado("Corinthians", 1, "Palmeiras", 1),
    ]),
    [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Palmeiras", 1, 0, 0)
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

/// Devolve True se um *time* está em um *resultado*. Devolve False caso contrário.
pub fn verifica_time(time: String, resultado: Resultado) -> Bool {
  resultado.anfitriao == time || resultado.visitante == time
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
  list.fold(desempenhos, Desempenho(time, 0, 0, 0), soma_desempenhos)
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

/// Soma o *desempenho1* com o *desempenho2*.
pub fn soma_desempenhos(desempenho1: Desempenho, desempenho2: Desempenho) -> Desempenho {
  Desempenho(
    desempenho1.time,
    desempenho1.pontos + desempenho2.pontos,
    desempenho1.vitorias + desempenho2.vitorias,
    desempenho1.saldo_gols + desempenho2.saldo_gols,
  )
}

/// Produz uma lista com os desempenhos de todos os times a partir de uma lista com os
/// nomes dos *times* e de uma lista com os *resultados* desses times.
pub fn lista_desempenhos(
  times: List(String),
  resultados: List(Resultado),
) -> List(Desempenho) {
  list.map(times, fn(time) {calcula_desempenho_total(time, calcula_desempenho_lista(time, resultados))})
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

/// Converte uma lista de *desempenhos* do tipo Desempenho
/// em uma lista no formato "time pontos vitórias saldo_de_gols".
pub fn desempenhos_para_strings(desempenhos: List(Desempenho)) -> List(String) {
  todo
}

/// Monta a classificação dos times a partir dos *resultados* de seus jogos.
// pub fn monta_classificacao(
//   resultados: List(String),
// ) -> Result(List(String), Erros) {
//   use resultados <- result.try(converte_resultados(resultados))
//   resultados
//   |> lista_times
//   |> lista_desempenhos(resultados)
//   |> ordena_times
//   |> desempenhos_para_strings
// }