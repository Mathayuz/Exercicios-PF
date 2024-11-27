import sgleam/check
import gleam/string
import gleam/list
import gleam/int

pub type Resultado {
  Resultado(anfitriao: String, gols_anfitriao: Int, visitante: String, gols_visitante: Int)
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
pub fn monta_classificacao(resultados: List(String)) -> List(String) {
  []
}

pub fn monta_classificacao_examples() {
  check.eq(monta_classificacao([]), [])
  check.eq(monta_classificacao(["Palmeiras 3 Corinthians 0"]), ["Palmeiras 3 1 3", "Corinthians 0 0 -3"])
  check.eq(monta_classificacao(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), ["Palmeiras 4 1 3", "Corinthians 1 0 -3"])
  check.eq(monta_classificacao(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), ["Flamengo 6 2 2", "Atletico-MG 3 1 0", "Palmeiras 1 0 -1", "Sao-Paulo 1 0 -1"])
}

/// Verifica se uma *lst* possui algum erro entre seus items
pub fn verifica_lista(lst: List(String)) -> Result(List(String), Erros) {
  case lst {
    [] -> Ok(lst)
    [primeiro, ..resto] -> case verifica_resultado(primeiro) {
      Ok(_) -> verifica_lista(resto)
      Error(erro) -> Error(erro)
    }
  }
}

pub fn verifica_lista_examples() {
  check.eq(verifica_lista([]), Ok([]))
  check.eq(verifica_lista(["Palmeiras 3 Corinthians"]), Error(QuantidadeCamposInvalida))
  check.eq(verifica_lista(["Palmeiras 3 Corinthians 0"]), Ok(["Palmeiras 3 Corinthians 0"]))
  check.eq(verifica_lista(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), Ok(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]))
}

/// Verifica uma string no formato "anfitrião gols visitante gols" em um Resultado.
/// Retorna um erro caso a string contenha um erro.
/// Os campos são separados por espaços e os gols devem ser números inteiros.
pub fn verifica_resultado(resultado: String) -> Result(String, Erros) {
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
              False -> Ok(resultado)
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
  check.eq(verifica_resultado("Palmeiras 3 Corinthians 0"), Ok("Palmeiras 3 Corinthians 0"))
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

/// Converte uma *lst* de strings no formato "anfitrião gols visitante gols" em uma lista de Resultados.
pub fn converte_lista(lst: List(String)) -> List(Resultado) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> list.append([converte_resultado(primeiro)], converte_lista(resto))
  }
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), [])
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), [Resultado("Palmeiras", 3, "Corinthians", 0), Resultado("Corinthians", 1, "Palmeiras", 1)])
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0"]), [Resultado("Palmeiras", 3, "Corinthians", 0)])
  check.eq(converte_lista(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), [Resultado("Sao-Paulo", 1, "Atletico-MG", 2), Resultado("Flamengo", 2, "Palmeiras", 1), Resultado("Palmeiras", 0, "Sao-Paulo", 0), Resultado("Atletico-MG", 1, "Flamengo", 2)])
}

/// Converte a string *resultado* para o tipo resultado
pub fn converte_resultado(resultado: String) -> Resultado {
  case string.split(resultado, " ") {
    [anfitriao, gols1, visitante, gols2] -> case int.parse(gols1), int.parse(gols2) {
      Ok(gols1), Ok(gols2) -> Resultado(anfitriao, gols1, visitante, gols2)
      _, _ -> Resultado()
    }
    _ -> Resultado()
  }
}

pub fn converte_resultado_examples() {
  check.eq(converte_resultado("Palmeiras 3 Corinthians 0"), Resultado("Palmeiras", 3, "Corinthians", 0))
}