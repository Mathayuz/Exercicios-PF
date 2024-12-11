import gleam/string
import gleam/int
import gleam/float
import sgleam/check

/// Exercício 10
pub type Direcao {
  Norte
  Sul
  Leste
  Oeste
}

pub fn direcao_oposta(direcao: Direcao) -> Direcao {
  case direcao {
    Norte -> Sul
    Sul -> Norte
    Leste -> Oeste
    Oeste -> Leste
  }
}

pub fn direcao_oposta_examples() {
  check.eq(direcao_oposta(Norte), Sul)
  check.eq(direcao_oposta(Sul), Norte)
  check.eq(direcao_oposta(Leste), Oeste)
  check.eq(direcao_oposta(Oeste), Leste)
}

pub fn direcao_90_graus_horario(direcao: Direcao) -> Direcao {
  case direcao {
    Norte -> Leste
    Leste -> Sul
    Sul -> Oeste
    Oeste -> Norte
  }
}

pub fn direcao_90_graus_horario_examples() {
  check.eq(direcao_90_graus_horario(Norte), Leste)
  check.eq(direcao_90_graus_horario(Leste), Sul)
  check.eq(direcao_90_graus_horario(Sul), Oeste)
  check.eq(direcao_90_graus_horario(Oeste), Norte)
}

pub fn direcao_90_graus_antihorario(direcao: Direcao) -> Direcao {
  direcao_90_graus_horario(direcao_90_graus_horario(direcao_90_graus_horario(direcao)))
}

pub fn direcao_90_graus_antihorario_examples() {
  check.eq(direcao_90_graus_antihorario(Norte), Oeste)
  check.eq(direcao_90_graus_antihorario(Oeste), Sul)
  check.eq(direcao_90_graus_antihorario(Sul), Leste)
  check.eq(direcao_90_graus_antihorario(Leste), Norte)
}

pub fn graus_direcao(direcao1 : Direcao, direcao2: Direcao) -> Int {
  case direcao1 == direcao_oposta(direcao2) {
    True -> 180
    False -> case direcao1 == direcao_90_graus_antihorario(direcao2) {
      True -> 90
      False -> case direcao1 == direcao2 {
          True -> 0
          False -> 270
        }
    }
  }
}

pub fn graus_direcao_examples() {
  check.eq(graus_direcao(Norte, Sul), 180)
  check.eq(graus_direcao(Norte, Norte), 0)
  check.eq(graus_direcao(Norte, Leste), 90)
  check.eq(graus_direcao(Norte, Oeste), 270)
  check.eq(graus_direcao(Sul, Leste), 270)
  check.eq(graus_direcao(Leste, Oeste), 180)
  check.eq(graus_direcao(Oeste, Norte), 90)
  check.eq(graus_direcao(Oeste, Sul), 270)
}

/// Exercício 11
pub type EstadoElevador {
  Parado
  Subindo
  Descendo
}

pub fn proximo_estado(andar_atual: Int, proximo_andar: Int) -> EstadoElevador {
  case andar_atual > proximo_andar {
    True -> Descendo
    False -> case andar_atual == proximo_andar {
      True -> Parado
      False -> Subindo
    }
  }
}

pub fn proximo_estado_examples() {
  check.eq(proximo_estado(1, 2), Subindo)
  check.eq(proximo_estado(2, 1), Descendo)
  check.eq(proximo_estado(2, 2), Parado)
}

pub fn pode_mover(estado1: EstadoElevador, estado2: EstadoElevador) -> Bool {
  case estado1, estado2 {
    Parado, _ -> True
    _, Parado -> True
    _, _ -> False
  }
}

pub fn pode_mover_examples() {
  check.eq(pode_mover(Parado, Parado), True)
  check.eq(pode_mover(Parado, Subindo), True)
  check.eq(pode_mover(Parado, Descendo), True)
  check.eq(pode_mover(Subindo, Parado), True)
  check.eq(pode_mover(Descendo, Parado), True)
  check.eq(pode_mover(Subindo, Subindo), False)
}

/// Exercício 12
pub type Data {
  Data(dia: String, mes: String, ano: String)
}

pub fn transforma_data(data: String) -> Data {
  Data(dia: string.slice(data, 0, 2), mes: string.slice(data, 3, 2), ano: string.slice(data, 6, 4))
}

pub fn transforma_data_examples() {
  check.eq(transforma_data("23/03/2005"), Data("23", "03", "2005"))
}

pub fn ultimo_dia(data: Data) -> Bool {
  case data {
    Data("31", "12", _) -> True
    Data(_, _, _) -> False
  }
}

pub fn ultimo_dia_examples() {
  check.eq(ultimo_dia(Data("23", "03", "2005")), False)
  check.eq(ultimo_dia(Data("31", "12", "2005")), True)
}

pub type DataInt {
  DataInt(dia: Int, mes: Int, ano: Int)
}

pub fn data_maior(data1: DataInt, data2: DataInt) -> Bool {
  case data1.ano > data2.ano {
    True -> False
    False -> case data1.mes > data2.mes {
      True -> False
      False -> case data1.dia > data2.dia {
        True -> False
        False -> True
      }
    }
  } 
}

pub fn data_maior_examples() {
  check.eq(data_maior(DataInt(23, 3, 2020), DataInt(31, 4, 2019)), False)
  check.eq(data_maior(DataInt(23, 3, 2018), DataInt(31, 4, 2019)), True)
  check.eq(data_maior(DataInt(23, 3, 2019), DataInt(31, 4, 2019)), True)
  check.eq(data_maior(DataInt(23, 5, 2019), DataInt(31, 4, 2019)), False)
  check.eq(data_maior(DataInt(23, 4, 2019), DataInt(31, 4, 2019)), True)
  check.eq(data_maior(DataInt(23, 4, 2018), DataInt(22, 4, 2019)), False)
}

pub fn data_valida(data: DataInt) -> Bool {
  case data.dia >= 1 && data.dia <= 31 {
    True -> case data.mes == 1 || data.mes == 3 || data.mes == 5 || data.mes == 7 || data.mes == 8 || data.mes == 10 || data.mes == 12 {
      True -> data.ano > 0
      False -> case data.ano % 100 != 0 && data.ano % 4 == 0 || data.ano % 400 == 0 {
        True -> case data.mes == 2 {
          True -> data.dia <= 29
          False -> data.dia <= 30
        }
        False -> case data.mes == 2 {
          True -> data.dia <= 28
          False -> data.dia <= 30
        }
      }
    }
    False -> False
  }
}

pub fn data_valida_examples() {
  check.eq(data_valida(DataInt(23, 03, 2005)), True)
  check.eq(data_valida(DataInt(31, 11, 2024)), False)
  check.eq(data_valida(DataInt(29, 02, 2024)), True)
  check.eq(data_valida(DataInt(29, 03, 2023)), True)
  check.eq(data_valida(DataInt(28, 02, 2023)), True)
  check.eq(data_valida(DataInt(32, 03, 2023)), False)
}

/// Exercício 14
pub type Figura {
  Retangulo(largura: Float, altura: Float)
  Circulo(raio: Float)
}

pub fn area(figura: Figura) -> Float {
  case figura {
    Retangulo(largura, altura) -> largura *. altura
    Circulo(raio) -> 3.14 *. raio *. raio
  }
}

pub fn area_examples() {
  check.eq(area(Retangulo(2.0, 3.0)), 6.0)
  check.eq(area(Circulo(2.0)), 12.56)
}

pub fn cabe_na_outra(figura1: Figura, figura2: Figura) -> Bool {
  case figura1, figura2 {
    Retangulo(largura1, altura1), Retangulo(largura2, altura2) ->  largura1 <=. largura2 && altura1 <=. altura2

    Circulo(raio1), Circulo(raio2) -> raio1 <=. raio2

    Retangulo(largura1, altura1), Circulo(raio2) -> case float.square_root({largura1 *. largura1 +. altura1 *. altura1}) {
      Ok(x) -> raio2 >=. x /. 2.0
      Error(Nil) -> False
    }
    Circulo(raio1), Retangulo(largura2, altura2) -> raio1 *. 2.0 <=. float.min(largura2, altura2)
  }
}

pub fn cabe_na_outra_examples() {
  check.eq(cabe_na_outra(Retangulo(2.0, 3.0), Retangulo(3.0, 4.0)), True)
  check.eq(cabe_na_outra(Retangulo(2.0, 3.0), Retangulo(1.0, 4.0)), False)
  check.eq(cabe_na_outra(Circulo(2.0), Circulo(3.0)), True)
  check.eq(cabe_na_outra(Circulo(2.0), Circulo(1.0)), False)
  check.eq(cabe_na_outra(Retangulo(2.0, 3.0), Circulo(3.0)), True)
  check.eq(cabe_na_outra(Retangulo(2.0, 3.0), Circulo(2.0)), True)
  check.eq(cabe_na_outra(Circulo(2.0), Retangulo(3.0, 4.0)), False)
  check.eq(cabe_na_outra(Circulo(2.0), Retangulo(2.0, 3.0)), False)
}

/// Exercício 22

/// Uma posição do jogador baseada na linha e na coluna que ele está.
pub type Posicao {
  Posicao(linha: Int, coluna: Int)
}

/// Um estado do jogador no jogo
pub type Estado {
  Estado(pos: Posicao, dir: Direcao)
}

/// Um comando que o jogador pode receber
pub type Comando {
  VirarEsquerda
  VirarDireita
  Avancar(v: Int)
}

pub fn novo_estado(estado: Estado, comando: Comando) -> Result(Estado, Nil) {
  case comando {
    VirarEsquerda -> Ok(Estado(estado.pos, direcao_90_graus_antihorario(estado.dir)))
    VirarDireita -> Ok(Estado(estado.pos, direcao_90_graus_horario(estado.dir)))
    Avancar(v) -> case estado.pos {
      Posicao(linha, coluna) -> case estado.dir {
        Norte -> case coluna + v > 10 {
          True -> Error(Nil)
          False -> Ok(Estado(Posicao(linha + v, coluna), estado.dir))
        }
        Sul -> case coluna - v < 1 {
          True -> Error(Nil)
          False -> Ok(Estado(Posicao(linha - v, coluna), estado.dir))
        }
        Leste -> case linha + v > 10 {
          True -> Error(Nil)
          False -> Ok(Estado(Posicao(linha, coluna + v), estado.dir))
        }
        Oeste -> case linha - v < 1 {
          True -> Error(Nil)
          False -> Ok(Estado(Posicao(linha, coluna - v), estado.dir))
        }
      }
    }
  }
}

pub fn novo_estado_examples() {
  check.eq(novo_estado(Estado(Posicao(1, 5), Norte), VirarDireita), Ok(Estado(Posicao(1, 5), Leste)))
  check.eq(novo_estado(Estado(Posicao(7, 5), Oeste), Avancar(2)), Ok(Estado(Posicao(7, 3), Oeste)))
}