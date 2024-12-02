import gleam/int
import gleam/order
import gleam/string
import sgleam/check

/// Representa um *resultado* de um jogo, com o nome do time *anfitrião*, a quantidade de gols
/// do time anfitrião, o nome do time *visitante* e a quantidade de gols do time visitante.
pub type Resultado {
  Resultado(
    anfitriao: String,
    gols_anfitriao: Int,
    visitante: String,
    gols_visitante: Int,
  )
}

/// Representa o *desempenho* de um time, com o nome do time, a quantidade de *pontos*,
/// a quantidade de *vitórias* e o *saldo de gols*.
pub type Desempenho {
  Desempenho(time: String, pontos: Int, vitorias: Int, saldo_gols: Int)
}

/// Representa os *erros* possíveis ao montar a classificação dos times.
pub type Erros {
  NaoEhNumeroAnfitriao
  NaoEhNumeroVisitante
  NaoEhNumeroAnfitriaoVisitante
  NumeroInvalidoAnfitriao
  NumeroInvalidoVisitante
  NumeroInvalidoAnfitriaoVisitante
  QuantidadeCamposInvalida
  MesmoTime
}

/// Verifica e converte um *resultado* no formato "anfitrião gols visitante gols" se ele for válido.
/// Caso não seja válido, retorna um erro.
pub fn converte_resultado(resultado: String) -> Result(Resultado, Erros) {
  case string.split(resultado, " ") {
    [anfitriao, gols1, visitante, gols2] ->
      case int.parse(gols1), int.parse(gols2) {
        Ok(gols1), Ok(gols2) ->
          case gols1 < 0 && gols2 < 0 {
            True -> Error(NumeroInvalidoAnfitriaoVisitante)
            False ->
              case gols1 < 0 {
                True -> Error(NumeroInvalidoAnfitriao)
                False ->
                  case gols2 < 0 {
                    True -> Error(NumeroInvalidoVisitante)
                    False ->
                      case anfitriao == visitante {
                        True -> Error(MesmoTime)
                        False ->
                          Ok(Resultado(anfitriao, gols1, visitante, gols2))
                      }
                  }
              }
          }
        Error(Nil), Ok(_) -> Error(NaoEhNumeroAnfitriao)
        Ok(_), Error(Nil) -> Error(NaoEhNumeroVisitante)
        Error(Nil), Error(Nil) -> Error(NaoEhNumeroAnfitriaoVisitante)
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

/// Verifica e converte uma lista de *resultados* se ela for válida.
/// Caso não seja válida, retorna um erro.
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
    converte_resultados(["Palmeiras 3 Corinthians 0"]),
    Ok([Resultado("Palmeiras", 3, "Corinthians", 0)]),
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

/// Verifica se um *time* está em uma *lista*
pub fn verifica_lista(time: String, lista: List(String)) -> Bool {
  case lista {
    [] -> False
    [primeiro, ..resto] ->
      case primeiro == time {
        True -> True
        False -> verifica_lista(time, resto)
      }
  }
}

pub fn verifica_lista_examples() {
  check.eq(verifica_lista("Palmeiras", []), False)
  check.eq(verifica_lista("Palmeiras", ["Corinthians", "Sao-Paulo"]), False)
  check.eq(verifica_lista("Palmeiras", ["Corinthians", "Palmeiras"]), True)
}

/// Retorna uma lista com os nomes de todos os times que estão em uma *lista* de resultados
pub fn lista_times(lista: List(Resultado)) -> List(String) {
  case lista {
    [] -> []
    [Resultado(anfitriao, _, visitante, _), ..resto] ->
      case
        verifica_lista(anfitriao, lista_times(resto)),
        verifica_lista(visitante, lista_times(resto))
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

/// Verifica se um *time* está em um *resultado*
pub fn verifica_time(time: String, resultado: Resultado) -> Bool {
  case resultado {
    Resultado(anfitriao, _, visitante, _) ->
      anfitriao == time || visitante == time
  }
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

/// Calcula o desempenho de um *time* baseado em um único *resultado*
pub fn calcula_desempenho(time: String, resultado: Resultado) -> Desempenho {
  case verifica_time(time, resultado) {
    True ->
      case resultado {
        Resultado(anfitriao, gols_anfitriao, _visitante, gols_visitante) ->
          case time == anfitriao {
            True ->
              case gols_anfitriao > gols_visitante {
                True -> Desempenho(time, 3, 1, gols_anfitriao - gols_visitante)
                False ->
                  case gols_anfitriao < gols_visitante {
                    True ->
                      Desempenho(time, 0, 0, gols_anfitriao - gols_visitante)
                    False -> Desempenho(time, 1, 0, 0)
                  }
              }
            False ->
              case gols_visitante > gols_anfitriao {
                True -> Desempenho(time, 3, 1, gols_visitante - gols_anfitriao)
                False ->
                  case gols_visitante < gols_anfitriao {
                    True ->
                      Desempenho(time, 0, 0, gols_visitante - gols_anfitriao)
                    False -> Desempenho(time, 1, 0, 0)
                  }
              }
          }
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

/// Calcula todos os desempenhos de um único *time* baseado nos *resultados* de seus jogos.
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

/// Calcula o desempenho total de um *time* baseado em uma lista de *desempenhos*.
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
    calcula_desempenho_total("Sao-Paulo", [
      Desempenho("Sao-Paulo", 0, 0, -1),
      Desempenho("Sao-Paulo", 0, 0, 0),
      Desempenho("Sao-Paulo", 1, 0, 0),
      Desempenho("Sao-Paulo", 0, 0, 0),
    ]),
    Desempenho("Sao-Paulo", 1, 0, -1),
  )
}

/// Recebe uma lista de *times* e uma lista de *resultados* e retorna uma lista com os *desempenhos*
/// de todos os times baseado nos resultados de seus jogos.
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

/// Ordena os times baseado em seus desempenhos.
/// A ordenação é feita pela quantidade de pontos, e em caso de empate, pelo número de vitórias,
/// depois pelo saldo de gols e por fim pela ordem alfabética.
pub fn ordena_times(
  desempenhos: List(Desempenho),
) -> Result(List(Desempenho), Erros) {
  case desempenhos {
    [] -> Ok([])
    [primeiro] -> Ok([primeiro])
    [primeiro, ..resto] ->
      case encontra_melhor_desempenho(resto) {
        Ok(melhor_desempenho) ->
          case primeiro == compara_desempenhos(primeiro, melhor_desempenho) {
            True ->
              case ordena_times(resto) {
                Ok(resto_ordenado) -> Ok([primeiro, ..resto_ordenado])
                Error(erro) -> Error(erro)
              }
            False ->
              case remove_desempenho(melhor_desempenho, desempenhos) {
                Ok(desempenhos_sem_melhor) ->
                  case ordena_times(desempenhos_sem_melhor) {
                    Ok(resto_ordenado) ->
                      Ok([melhor_desempenho, ..resto_ordenado])
                    Error(erro) -> Error(erro)
                  }
                Error(erro) -> Error(erro)
              }
          }
        Error(erro) -> Error(erro)
      }
  }
}

pub fn ordena_times_examples() {
  check.eq(ordena_times([]), Ok([]))
  check.eq(
    ordena_times([Desempenho("Palmeiras", 3, 1, 3)]),
    Ok([Desempenho("Palmeiras", 3, 1, 3)]),
  )
  check.eq(
    ordena_times([
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    Ok([Desempenho("Palmeiras", 3, 1, 3), Desempenho("Corinthians", 0, 0, -3)]),
  )
  check.eq(
    ordena_times([
      Desempenho("Corinthians", 0, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    Ok([Desempenho("Palmeiras", 4, 1, 3), Desempenho("Corinthians", 0, 0, -3)]),
  )
  check.eq(
    ordena_times([
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    Ok([
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Palmeiras", 1, 0, -1),
      Desempenho("Sao-Paulo", 1, 0, -1),
    ]),
  )
}

/// Compara dois *desempenhos* e retorna o melhor desempenho.
pub fn compara_desempenhos(
  desempenho1: Desempenho,
  desempenho2: Desempenho,
) -> Desempenho {
  case desempenho1.pontos > desempenho2.pontos {
    True -> desempenho1
    False ->
      case desempenho1.pontos < desempenho2.pontos {
        True -> desempenho2
        False ->
          case desempenho1.vitorias > desempenho2.vitorias {
            True -> desempenho1
            False ->
              case desempenho1.vitorias < desempenho2.vitorias {
                True -> desempenho2
                False ->
                  case desempenho1.saldo_gols > desempenho2.saldo_gols {
                    True -> desempenho1
                    False ->
                      case desempenho1.saldo_gols < desempenho2.saldo_gols {
                        True -> desempenho2
                        False ->
                          case
                            string.compare(desempenho1.time, desempenho2.time)
                          {
                            order.Lt -> desempenho1
                            _ -> desempenho2
                          }
                      }
                  }
              }
          }
      }
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

/// Encontra o melhor desempenho de uma lista de *desempenhos*.
pub fn encontra_melhor_desempenho(
  desempenhos: List(Desempenho),
) -> Result(Desempenho, Erros) {
  case desempenhos {
    [] -> Error(QuantidadeCamposInvalida)
    [primeiro] -> Ok(primeiro)
    [primeiro, ..resto] ->
      case encontra_melhor_desempenho(resto) {
        Ok(melhor_resto) ->
          case compara_desempenhos(primeiro, melhor_resto) {
            Desempenho(time, pontos, vitorias, saldo_gols) ->
              Ok(Desempenho(time, pontos, vitorias, saldo_gols))
          }
        Error(erro) -> Error(erro)
      }
  }
}

pub fn encontra_melhor_desempenho_examples() {
  check.eq(encontra_melhor_desempenho([]), Error(QuantidadeCamposInvalida))
  check.eq(
    encontra_melhor_desempenho([Desempenho("Palmeiras", 3, 1, 3)]),
    Ok(Desempenho("Palmeiras", 3, 1, 3)),
  )
  check.eq(
    encontra_melhor_desempenho([
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    Ok(Desempenho("Palmeiras", 3, 1, 3)),
  )
  check.eq(
    encontra_melhor_desempenho([
      Desempenho("Corinthians", 1, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    Ok(Desempenho("Palmeiras", 4, 1, 3)),
  )
  check.eq(
    encontra_melhor_desempenho([
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    Ok(Desempenho("Flamengo", 6, 2, 2)),
  )
}

/// Remove um *desempenho* de uma lista de *desempenhos*.
pub fn remove_desempenho(
  desempenho: Desempenho,
  desempenhos: List(Desempenho),
) -> Result(List(Desempenho), Erros) {
  case desempenhos {
    [] -> Error(QuantidadeCamposInvalida)
    [primeiro, ..resto] ->
      case primeiro == desempenho {
        True -> Ok(resto)
        False ->
          case remove_desempenho(desempenho, resto) {
            Ok(resto_sem_elemento) -> Ok([primeiro, ..resto_sem_elemento])
            Error(erro) -> Error(erro)
          }
      }
  }
}

pub fn remove_desempenho_examples() {
  check.eq(
    remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), []),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), [
      Desempenho("Palmeiras", 3, 1, 3),
    ]),
    Ok([]),
  )
  check.eq(
    remove_desempenho(Desempenho("Palmeiras", 3, 1, 3), [
      Desempenho("Palmeiras", 3, 1, 3),
      Desempenho("Corinthians", 0, 0, -3),
    ]),
    Ok([Desempenho("Corinthians", 0, 0, -3)]),
  )
  check.eq(
    remove_desempenho(Desempenho("Corinthians", 0, 0, -3), [
      Desempenho("Corinthians", 0, 0, -3),
      Desempenho("Palmeiras", 4, 1, 3),
    ]),
    Ok([Desempenho("Palmeiras", 4, 1, 3)]),
  )
  check.eq(
    remove_desempenho(Desempenho("Sao-Paulo", 1, 0, -1), [
      Desempenho("Sao-Paulo", 1, 0, -1),
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
    Ok([
      Desempenho("Atletico-MG", 3, 1, 0),
      Desempenho("Flamengo", 6, 2, 2),
      Desempenho("Palmeiras", 1, 0, -1),
    ]),
  )
}

/// Transforma uma lista de *desempenhos* em uma lista de strings no formato "time pontos vitórias saldo de gols".
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

/// Recebe os *resultados* dos jogos e retorna a *classificação* dos times.
/// Uma vitória vale 3 pontos, um empate vale 1 ponto e uma derrota vale 0 pontos.
/// A classificação é dada pela quantidade de pontos, e em caso de empate, pelo número de vitórias,
/// depois pelo saldo de gols e por fim pela ordem alfabética.
/// Os resultados são strings no formato "anfitrião gols visitante gols".
/// A classificação é uma lista de strings no formato "time pontos vitórias saldo de gols".
pub fn monta_classificacao(
  resultados: List(String),
) -> Result(List(String), Erros) {
  case converte_resultados(resultados) {
    Ok(resultados) ->
      case lista_desempenhos(lista_times(resultados), resultados) {
        desempenhos ->
          case ordena_times(desempenhos) {
            Ok(desempenhos) -> Ok(desempenhos_para_strings(desempenhos))
            Error(erro) -> Error(erro)
          }
      }
    Error(erro) -> Error(erro)
  }
}

pub fn monta_classificacao_examples() {
  check.eq(monta_classificacao([]), Ok([]))
  check.eq(
    monta_classificacao(["Palmeiras 3 Corinthians 0 0"]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    monta_classificacao(["Palmeiras 3 Corinthians"]),
    Error(QuantidadeCamposInvalida),
  )
  check.eq(
    monta_classificacao(["Palmeiras a Corinthians 0"]),
    Error(NaoEhNumeroAnfitriao),
  )
  check.eq(
    monta_classificacao(["Palmeiras 3 Corinthians a"]),
    Error(NaoEhNumeroVisitante),
  )
  check.eq(
    monta_classificacao(["Palmeiras a Corinthians b"]),
    Error(NaoEhNumeroAnfitriaoVisitante),
  )
  check.eq(
    monta_classificacao(["Palmeiras -1 Corinthians 0"]),
    Error(NumeroInvalidoAnfitriao),
  )
  check.eq(
    monta_classificacao(["Palmeiras 3 Corinthians -1"]),
    Error(NumeroInvalidoVisitante),
  )
  check.eq(
    monta_classificacao(["Palmeiras -3 Corinthians -1"]),
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
