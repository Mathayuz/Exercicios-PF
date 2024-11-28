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
pub fn monta_classificacao(resultados: List(String)) -> Result(List(String), Erros) {
  todo
}

/// Verifica e converte um *resultado* no formato "anfitrião gols visitante gols" se ele for válido.
/// Caso não seja válido, retorna um erro.
pub fn converte_resultado(resultado: String) -> Result(Resultado, Erros) {
  todo
}

/// Verifica e converte uma lista de *resultados* se ela for válida.
/// Caso não seja válida, retorna um erro.
pub fn converte_resultados(resultados: List(String)) -> Result(List(Resultado), Erros) {
  todo
}

/// Calcula o *desempenho* de um *time* a partir de uma lista de *resultados*.
/// Uma vitória vale 3 pontos, um empate vale 1 ponto e uma derrota vale 0 pontos.
/// O saldo de gols é a diferença entre gols feitos e gols sofridos.
pub fn calcula_desempenho(time: String, resultados: List(Resultado)) -> Desempenho {
  todo
}

/// Atualiza o *desempenho* de um *time* a partir de um *resultado*.
pub fn atualiza_desempenho(desempenho: Desempenho, resultado: Resultado) -> Desempenho {
  todo
}

/// Ordena a *classificação* dos times.
/// A classificação é dada pela quantidade de pontos, e em caso de empate, pelo número de vitórias,
/// depois pelo saldo de gols e por fim pela ordem alfabética.
pub fn ordena_classificacao(classificacao: List(Desempenho)) -> List(Desempenho) {
  todo
}

