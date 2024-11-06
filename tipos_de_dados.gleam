import gleam/io
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

pub fn main() {
  io.println("Hello World!")
}