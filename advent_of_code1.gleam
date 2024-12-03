import sgleam/check

/// Verifica os 2 menores números de cada uma das listas e devolve a diferença entre eles,
/// depois verifica os 2 segundos menores números de cada uma das listas e soma com o valor obtido
/// anteriormente, e assim continua até o fim das duas listas, no fim retorna a soma das diferenças entre
/// os menores valores da cada lista
pub fn soma_menores(lista1: List(Int), lista2: List(Int)) -> Int {
  
}

pub fn soma_menores_examples() {
  check.eq(soma_menores([3], [1]), 2)
  check.eq(soma_menores([3], [3]), 0)
  check.eq(soma_menores([3], [4]), 1)
  check.eq(soma_menores([3, 4, 2, 10], [4, 5, 16, 4]), 10)
}

pub fn encontra_menor(lista: List(Int)) -> Result(Int, Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro] -> Ok(primeiro)
    [primeiro, ..resto] -> case encontra_menor(resto) {
      Ok(menor) -> case primeiro < menor {
        True -> Ok(primeiro)
        False -> Ok(menor)
      }
      Error(erro) -> Error(erro)
    }
  }
}

pub fn encontra_menor_examples() {
  check.eq(encontra_menor([]), Error(Nil))
  check.eq(encontra_menor([1]), Ok(1))
  check.eq(encontra_menor([1, 2]), Ok(1))
  check.eq(encontra_menor([2, 1]), Ok(1))
  check.eq(encontra_menor([3, 1, 2]), Ok(1))
}