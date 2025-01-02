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