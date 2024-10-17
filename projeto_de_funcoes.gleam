import gleam/string
import gleam/int
import gleam/float
import sgleam/check

/// Exercício 13
/// Produz True se uma pessoa com *idade* é isento da
/// tarifa de transporte público, isto é, tem menos
/// que 18 anos ou 65 ou mais. Produz False caso contrário.
pub fn isento_tarifa(idade: Int) -> Bool {
  idade < 18 || idade >= 65
}
pub fn isento_tarifa_examples() {
  check.eq(isento_tarifa(17), True)
  check.eq(isento_tarifa(18), False)
  check.eq(isento_tarifa(50), False)
  check.eq(isento_tarifa(65), True)
  check.eq(isento_tarifa(70), True)
}

/// Exercício 14
/// Conta a quantidade de dígitos de *n*.
/// Se *n* é 0, então devolve zero.
/// Se *n* é menor que zero, então devolve a quantidade
/// de dígitos do valor absoluto de *n*.
pub fn quantidade_digitos(n: Int) -> Int {
  case n < 0 {
    True -> string.length(int.to_string(n)) - 1
    False -> string.length(int.to_string(n))
  }
}

pub fn quantidade_digitos_examples() {
  check.eq(quantidade_digitos(123), 3)
  check.eq(quantidade_digitos(0), 1)
  check.eq(quantidade_digitos(-1519), 4)
}

/// Exercício 15
/// Produz True se uma pessoa com a *idade* é supercentenária,
/// isto é, tem 110 anos ou mais, False caso contrário.
pub fn supercentenario(idade: Int) -> Bool {
  idade >= 110
}
pub fn supercentenario_examples() {
  check.eq(supercentenario(101), False)
  check.eq(supercentenario(110), True)
  check.eq(supercentenario(112), True)
}

/// Exercício 16
/// Transforma a string *data* que está no formato "dia/mes/ano"
/// para o formato "ano/mes/dia".
///
/// Requer que o dia e o mês tenham dois dígitos e que
/// o ano tenha quatro dígitos.
pub fn dma_para_amd(data: String) -> String {
  string.slice(data, 6, 4) <> string.slice(data, 2, 4) <> string.slice(data, 0, 2)
}
pub fn dma_para_amd_examples() {
  check.eq(dma_para_amd("19/07/2023"), "2023/07/19")
  check.eq(dma_para_amd("01/01/1980"), "1980/01/01")
  check.eq(dma_para_amd("20/02/2002"), "2002/02/20")
}

/// Exercício 17
/// Produz o valor de *valor* com um aumento de *porcentagem*.
pub fn aumenta(valor: Float, porcentagem: Float) -> Float {
  valor *. {1.0 +. porcentagem /. 100.0}
}

/// Exercício 18
/// Verifica o tamanho do *nome* de uma pessoa
/// produz "curto" se o nome tem até 4 caracteres
/// produz "médio" se o nome tem até 10 caracteres
/// produz "longo" se o nome tem mais de 10 caracteres
pub fn tamanho_nome(nome: String) -> String {
  case string.length(nome) <= 4 {
    True -> "curto"
    False -> case string.length(nome) <= 10 {
      True -> "médio" 
      False -> "longo"
    }
  }
}

/// Exercício 19
/// Coloca um ponto final no final da *frase*.
/// se a frase não termina com um ponto final.
pub fn coloca_ponto_final(frase: String) -> String {
  case string.slice(frase, -1, 1) == "." {
    True -> frase
    False -> frase <> "."
  }
}

pub fn coloca_ponto_final_examples() {
  check.eq(coloca_ponto_final("Olá, mundo"), "Olá, mundo.")
  check.eq(coloca_ponto_final("Olá, mundo."), "Olá, mundo.")
}

/// Exercício 20
/// Determina se a *palavra* tem um traço ("-") no meio
/// produz True se tiver, False caso contrário.
pub fn tem_traco(palavra: String) -> Bool {
  string.contains(palavra, "-")
}

pub fn tem_traco_examples() {
  check.eq(tem_traco("casa"), False)
  check.eq(tem_traco("casa-grande"), True)
}

/// Exercício 21
/// Encontra e devolove o valor o máximo 
/// entre *a*, *b* e *c*.
pub fn maximo(a: Int, b: Int, c: Int) -> Int {
  case a > b {
    True -> case a > c {
      True -> a
      False -> c
    }
    False -> case b > c {
      True -> b
      False -> c
    }
  }
}

pub fn maximo_examples() {
  check.eq(maximo(1, 2, 3), 3)
  check.eq(maximo(3, 2, 1), 3)
  check.eq(maximo(2, 3, 1), 3)
  check.eq(maximo(1, 3, 2), 3)
  check.eq(maximo(2, 1, 3), 3)
  check.eq(maximo(3, 1, 2), 3)
}

/// Exercício 22
/// Substitue os *n* primeiros caracteres da *string* por *n* letras x
/// e devolva a nova string.
pub fn substitui_por_x(string: String, n: Int) -> String {
  case string.length(string) < n {
    True -> string
    False -> string.repeat("x", n) <> string.slice(string, n, string.length(string))
  }
}

pub fn substitui_por_x_examples() {
  check.eq(substitui_por_x("abcdef", 3), "xxxdef")
  check.eq(substitui_por_x("abcdef", 0), "abcdef")
  check.eq(substitui_por_x("abcdef", 6), "xxxxxx")
}
