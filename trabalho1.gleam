import sgleam/check
import gleam/string
import gleam/list

pub type Resultado {
  Resultado(anfitriao: String, gols_anfitriao: Int, visitante: String, gols_visitante: Int)
}

pub type Erros {
  NaoEhNumero
  NumeroInvalido
  MaisCampos
  MenosCampos
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

/// Converte uma lista de strings no formato "anfitrião gols visitante gols" em uma lista de Resultados.
pub fn converte_lista(lst: List(String)) -> List(Resultado) {
  case lst {
    [] -> []
    [primeiro, ..resto] -> case converte_resultado(primeiro) {
        Ok(primeiro) -> list.append([primeiro], converte_lista(resto))
        Error(erro) -> erro
    }
  }
}

pub fn converte_lista_examples() {
  check.eq(converte_lista([]), [])
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0"]), [Resultado("Palmeiras", 3, "Corinthians", 0)])
  check.eq(converte_lista(["Palmeiras 3 Corinthians 0", "Corinthians 1 Palmeiras 1"]), [Resultado("Palmeiras", 3, "Corinthians", 0), Resultado("Corinthians", 1, "Palmeiras", 1)])
  check.eq(converte_lista(["Sao-Paulo 1 Atletico-MG 2", "Flamengo 2 Palmeiras 1", "Palmeiras 0 Sao-Paulo 0", "Atletico-MG 1 Flamengo 2"]), [Resultado("Sao-Paulo", 1, "Atletico-MG", 2), Resultado("Flamengo", 2, "Palmeiras", 1), Resultado("Palmeiras", 0, "Sao-Paulo", 0), Resultado("Atletico-MG", 1, "Flamengo", 2)])
}

/// Converte uma string no formato "anfitrião gols visitante gols" em um Resultado.
/// Retorna um erro caso a string não tenha 4 campos ou os campos não sejam válidos.
/// Os campos são separados por espaços e os gols devem ser números inteiros.
pub fn converte_resultado(resultado: String) -> Result(Resultado, Erros) {
  case String.split(resultado, " ") {
    [anfitriao, gols_anfitriao, visitante, gols_visitante] -> case int.parse(gols_anfitriao) {
        Ok(gols_anfitriao) -> case int.parse(gols_visitante) {
            Ok(gols_visitante) -> Resultados(anfitriao, gols_anfitriao, visitante, gols_visitante)
            Error(Nil) -> Error(NaoEhNumero)
        }
        Error(Nil) -> Error(NaoEhNumero)
    }
    _ -> Error(MaisCampos)
  }
}

pub fn converte_resultado_examples() {
  check.eq(converte_resultado("Palmeiras 3 Corinthians 0"), Ok(Resultado("Palmeiras", 3, "Corinthians", 0)))
  check.eq(converte_resultado("Palmeiras 3 Corinthians"), Error(MenosCampos))
  check.eq(converte_resultado("Palmeiras 3 Corinthians 0 0"), Error(MaisCampos))
  check.eq(converte_resultado("Palmeiras a Corinthians 0"), Error(NaoEhNumero))
  check.eq(converte_resultado("Palmeiras 3 Corinthians a"), Error(NaoEhNumero))
  check.eq(converte_resultado("Palmeiras 3 Corinthians -1"), Error(NumeroInvalido))
}
