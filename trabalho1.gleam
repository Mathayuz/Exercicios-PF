import sgleam/check
import gleam/string
import gleam/list
import gleam/int

pub type Resultado {
  Resultado(anfitriao: String, gols_anfitriao: Int, visitante: String, gols_visitante: Int)
}

pub type Desempenho {
  Desempenho(time: String, pontos: Int, vitorias: Int, saldo_gols: Int)
}

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

/// Recebe os *resultados* dos jogos e retorna a *classificação* dos times.
/// Uma vitória vale 3 pontos, um empate vale 1 ponto e uma derrota vale 0 pontos.
/// A classificação é dada pela quantidade de pontos, e em caso de empate, pelo número de vitórias,
/// depois pelo saldo de gols e por fim pela ordem alfabética.
/// Os resultados são strings no formato "anfitrião gols visitante gols".
/// A classificação é uma lista de strings no formato "time pontos vitórias saldo de gols".
pub fn monta_classificacao(resultados: List(String)) -> Result(List(String), Erros) {
  case converte_lista(resultados) {
    Ok(resultados) -> case monta_classificacao_aux(resultados) {
      Ok(classificacao) -> Ok(classificacao)
      Error(erro) -> Error(erro)
    }
    Error(erro) -> Error(erro)
  }
}

pub fn monta_classificacao_examples() {
  check.eq(monta_classificacao([]), [])
  check.eq(monta_classificacao(["Palmeiras 3 Corinthians 0"]), Ok(["Palmeiras 3 1 3", "Corinthians 0 0 -3"]))
  check.eq(monta_classificacao(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), Ok(["Palmeiras 4 1 3", "Corinthians 1 0 -3"]))
  check.eq(monta_classificacao(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), Ok(["Flamengo 6 2 2", "Atletico-MG 3 1 0", "Palmeiras 1 0 -1", "Sao-Paulo 1 0 -1"]))
}

/// Verifica uma string no formato "anfitrião gols visitante gols" em um Resultado.
/// Retorna um erro caso a string contenha um erro.
/// Os campos são separados por espaços e os gols devem ser números inteiros.
pub fn verifica_resultado(resultado: String) -> Result(Resultado, Erros) {
  case string.split(resultado, " ") {
    [anfitriao, gols1, visitante, gols2] -> case int.parse(gols1), int.parse(gols2) {
      Ok(gols1), Ok(gols2) -> case gols1 < 0 && gols2 < 0 {
        True -> Error(NumeroInvalidoAnfitriaoVisitante)
        False -> case gols1 < 0 {
          True -> Error(NumeroInvalidoAnfitriao)
          False -> case gols2 < 0 {
            True -> Error(NumeroInvalidoVisitante)
            False -> case anfitriao == visitante {
              True -> Error(MesmoTime)
              False -> Ok(Resultado(anfitriao, gols1, visitante, gols2))
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

pub fn verifica_resultado_examples() {
  check.eq(verifica_resultado("Palmeiras 3 Corinthians 0"), Ok(Resultado("Palmeiras", 3, "Corinthians", 0)))
  check.eq(verifica_resultado("Palmeiras 3 Corinthians"), Error(QuantidadeCamposInvalida))
  check.eq(verifica_resultado("Palmeiras 3 Corinthians 0 0"), Error(QuantidadeCamposInvalida))
  check.eq(verifica_resultado("Palmeiras a Corinthians 0"), Error(NaoEhNumeroAnfitriao))
  check.eq(verifica_resultado("Palmeiras 3 Corinthians a"), Error(NaoEhNumeroVisitante))
  check.eq(verifica_resultado("Palmeiras a Corinthians b"), Error(NaoEhNumeroAnfitriaoVisitante))
  check.eq(verifica_resultado("Palmeiras -1 Corinthians 0"), Error(NumeroInvalidoAnfitriao))
  check.eq(verifica_resultado("Palmeiras 3 Corinthians -1"), Error(NumeroInvalidoVisitante))
  check.eq(verifica_resultado("Palmeiras -3 Corinthians -1"), Error(NumeroInvalidoAnfitriaoVisitante))
  check.eq(verifica_resultado("Palmeiras 3 Palmeiras 0"), Error(MesmoTime))
}

/// Converte uma *lst* de strings no formato "anfitrião gols visitante gols" em uma lista de Resultados ou retorna um erro.
pub fn converte_lista(lst: List(String)) -> Result(List(Resultado), Erros) {
  case lst {
    [] -> Ok([])
    [resultado, ..resto] -> case verifica_resultado(resultado), converte_lista(resto) {
      Ok(resultado), Ok(resto) -> Ok([resultado, ..resto])
      Error(erro), _ -> Error(erro)
      _, Error(erro) -> Error(erro)
    }
  }
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), Ok([]))
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0"]), Ok([Resultado("Palmeiras", 3, "Corinthians", 0)]))
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), Ok([Resultado("Palmeiras", 3, "Corinthians", 0), Resultado("Corinthians", 1, "Palmeiras", 1)]))
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0"]), Ok([Resultado("Palmeiras", 3, "Corinthians", 0)]))
  check.eq(converte_lista(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), Ok([Resultado("Sao-Paulo", 1, "Atletico-MG", 2), Resultado("Flamengo", 2, "Palmeiras", 1), Resultado("Palmeiras", 0, "Sao-Paulo", 0), Resultado("Atletico-MG", 1, "Flamengo", 2)]))
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0 0"]), Error(QuantidadeCamposInvalida))
  check.eq(converte_lista(["Palmeiras 3 Corinthians"]), Error(QuantidadeCamposInvalida))
  check.eq(converte_lista(["Palmeiras a Corinthians 0"]), Error(NaoEhNumeroAnfitriao))
  check.eq(converte_lista(["Palmeiras 3 Corinthians a"]), Error(NaoEhNumeroVisitante))
  check.eq(converte_lista(["Palmeiras a Corinthians b"]), Error(NaoEhNumeroAnfitriaoVisitante))
  check.eq(converte_lista(["Palmeiras -1 Corinthians 0"]), Error(NumeroInvalidoAnfitriao))
  check.eq(converte_lista(["Palmeiras 3 Corinthians -1"]), Error(NumeroInvalidoVisitante))
  check.eq(converte_lista(["Palmeiras -3 Corinthians -1"]), Error(NumeroInvalidoAnfitriaoVisitante))
  check.eq(converte_lista(["Palmeiras 3 Palmeiras 0"]), Error(MesmoTime))
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1", "Palmeiras 3 Corinthians 0", "Corinthians 1 Corinthians 1"]), Error(MesmoTime))
}

/// Gera um desempenho para um time baseado em um resultado.
pub fn calcula_desempenho_anfitriao(resultado: Resultado) -> Desempenho {
  case resultado {
    Resultado(anfitriao, gols_anfitriao, visitante, gols_visitante) -> case gols_anfitriao > gols_visitante {
      True -> Desempenho(anfitriao, 3, 1, gols_anfitriao - gols_visitante)
      False -> case gols_anfitriao < gols_visitante {
        True -> Desempenho(antriao, 0, 0, gols_visitante - gols_anfitriao)
        False -> Desempenho(anfitriao, 1, 0, 0)
      }
    }
  }
}

pub fn calcula_desempenho_anfitriao_examples() {
  check.eq(calcula_desempenho_anfitriao(Resultado("Palmeiras", 3, "Corinthians", 0)), Desempenho("Palmeiras", 3, 1, 3))
  check.eq(calcula_desempenho_anfitriao(Resultado("Corinthians", 1, "Palmeiras", 1)), Desempenho("Corinthians", 1, 0, 0))
  check.eq(calcula_desempenho_anfitriao(Resultado("Sao-Paulo", 1, "Atletico-MG", 2)), Desempenho("Sao-Paulo", 0, 0, -1))
}

pub fn calcula_desempenho_visitante(resultado: Resultado) -> Desempenho {
  case resultado {
    Resultado(anfitriao, gols_anfitriao, visitante, gols_visitante) -> case gols_anfitriao > gols_visitante {
      True -> Desempenho(visitante, 0, 0, gols_visitante - gols_anfitriao)
      False -> case gols_anfitriao < gols_visitante {
        True -> Desempenho(visitante, 3, 1, gols_visitante - gols_anfitriao)
        False -> Desempenho(visitante, 1, 0, 0)
      }
    }
  }
}

pub fn calcula_desempenho_visitante_examples() {
  check.eq(calcula_desempenho_visitante(Resultado("Palmeiras", 3, "Corinthians", 0)), Desempenho("Corinthians", 0, 0, -3))
  check.eq(calcula_desempenho_visitante(Resultado("Corinthians", 1, "Palmeiras", 1)), Desempenho("Palmeiras", 1, 0, 0))
  check.eq(calcula_desempenho_visitante(Resultado("Sao-Paulo", 1, "Atletico-MG", 2)), Desempenho("Atletico-MG", 3, 1, 1))
}

/// Atualiza o desempenho de um time baseado em um resultado.
pub fn atualiza_desempenho(desempenho: Desempenho, resultado: Resultado) -> Desempenho {
  case resultado {
    Resultado(anfitriao, gols_anfitriao, visitante, gols_visitante) -> case anfitriao == desempenho.time {
      True -> case gols_anfitriao > gols_visitante {
        True -> Desempenho(desempenho.time, desempenho.pontos + 3, desempenho.vitorias + 1, desempenho.saldo_gols + gols_anfitriao - gols_visitante)
        False -> case gols_anfitriao < gols_visitante {
          True -> Desempenho(desempenho.time, desempenho.pontos, desempenho.vitorias, desempenho.saldo_gols + gols_anfitriao - gols_visitante)
          False -> Desempenho(desempenho.time, desempenho.pontos + 1, desempenho.vitorias, desempenho.saldo_gols)
        }
      }
      False -> case visitante == desempenho.time {
        True -> case gols_anfitriao > gols_visitante {
          True -> Desempenho(desempenho.time, desempenho.pontos, desempenho.vitorias, desempenho.saldo_gols + gols_visitante - gols_anfitriao)
          False -> case gols_anfitriao < gols_visitante {
            True -> Desempenho(desempenho.time, desempenho.pontos + 3, desempenho.vitorias + 1, desempenho.saldo_gols + gols_visitante - gols_anfitriao)
            False -> Desempenho(desempenho.time, desempenho.pontos + 1, desempenho.vitorias, desempenho.saldo_gols)
          }
        }
      }
    }
  }
}

pub fn atualiza_desempenho_examples() {
  check.eq(atualiza_desempenho(Desempenho("Palmeiras", 3, 1, 3), Resultado("Corinthians", 1, "Palmeiras", 1)), Desempenho("Palmeiras", 4, 1, 3))
  check.eq(atualiza_desempenho(Desempenho("Corinthians", 1, 0, 0), Resultado("Corinthians", 1, "Palmeiras", 1)), Desempenho("Corinthians", 1, 0, 0))
  check.eq(atualiza_desempenho(Desempenho("Sao-Paulo", 1, 0, -1), Resultado("Sao-Paulo", 1, "Atletico-MG", 2)), Desempenho("Sao-Paulo", 1, 0, -1))
}

/// Ordena os times baseado em seus desempenhos.
/// A ordenação é feita pela quantidade de pontos, e em caso de empate, pelo número de vitórias,
/// depois pelo saldo de gols e por fim pela ordem alfabética.
pub fn ordena_times() {
  todo
}