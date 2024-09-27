import gleam/io 

pub fn dobro(n: Int) -> Int {
  n * 2
}

pub fn main() {
  let n = 5
  let resultado = dobro(n)
  io.debug(resultado)
}