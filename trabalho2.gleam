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