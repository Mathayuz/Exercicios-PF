import gleam/io
import gleam/string
import sgleam/check

pub fn dobro(n: Int) -> Int {
  n * 2
}

/// Exercício 12
pub fn area_retangulo(altura, largura) {
  altura * largura
}

/// Exercício 13
pub fn produto_anterior_posterior(n: Int) -> Int {
  {n-1} * {n} * {n+1}
}

/// Exercício 14
pub fn so_primeira_maiuscula(palavra: String) -> String {
  string.capitalise(palavra)
}

/// Exercício 15
pub fn eh_par(n: Int) -> Bool {
  n % 2 == 0
}

/// Exercício 16
pub fn tres_digitos(n: Int) -> Bool {
  100 <= n && n <= 999
}

/// Exercício 17
pub fn maximo(a: Int, b: Int) -> Int {
  case a > b {
    True -> a
    False -> b
  }
}

/// Exercício 18
pub fn ordem(a: Int, b: Int, c: Int) -> String {
  case a > b && b > c {
    True -> "decrescente" 
    False -> case c > b && b > a {
      True -> "crescente"
      False -> "sem ordem"
    }
  }
}

pub fn and(x: Bool, y: Bool) -> Bool {
  case x {
    True -> y
    False -> False
  }
}

pub fn or(x:Bool, y: Bool) -> Bool {
  case x {
    True -> True
    False -> y
  }
}

pub fn or_examples() {
  check.eq(or(True, False), True) // sexo encanta
}

pub fn main() {
  io.println("Hello World!")
}