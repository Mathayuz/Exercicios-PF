import gleam/io
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

/// Exercício 23
/// Verifica o "texto" e diz se está de acordo com a regra
/// "sem espaços extras", que diz que o texto não deve conter espaços
/// no começo e no final.
pub fn sem_espacos_extra(texto: String) -> Bool {
  string.slice(texto, 0, 1) != " " && string.slice(texto, string.length(texto) - 1, 1) != " "
}

pub fn sem_espacos_extra_examples() {
  check.eq(sem_espacos_extra(" aaaa"), False)
  check.eq(sem_espacos_extra(" aaa "), False)
  check.eq(sem_espacos_extra("aaa "), False)
  check.eq(sem_espacos_extra("aaaa"), True)
}

/// Exercício 24
/// Calcula o imposto que deve ser pago por um cidadão, com base na sua *renda*
/// Cidadãos que recebem até 1000 dinheiros pagam 5% de imposto. Cidadãos que recebem entre 1000 e
/// 5000 dinheiros pagam 5% de imposto sobre 1000 dinheiros e 10% sobre o que passar de 1000. Cidadãos
/// que recebem mais de 5000 dinheiros pagam 5% de imposto sobre 1000 dinheiros, 10% de imposto sobre
/// 4000 dinheiros e 20% sobre o que passar de 5000.
pub fn calcula_imposto(renda: Float) -> Float {
  case renda <. 1000.0 {
    True -> renda *. 0.05
    False -> case renda >=. 1000.0 && renda <. 5000.0 {
      True -> 50.0 +. {renda -. 1000.0} *. 0.1
      False -> 50.0 +. 400.0 +. {renda -. 5000.0} *. 0.2
    }
  }
}

pub fn calcula_imposto_examples() {
  check.eq(calcula_imposto(700.0), 35.0)
  check.eq(calcula_imposto(999.0), 49.95)
  check.eq(calcula_imposto(4999.0), 449.90000000000003)
  check.eq(calcula_imposto(10000.0), 1450.0)
}

/// Exercício 25
/// Verifica se uma *palavra* é uma palavra duplicada, podendo ser
/// separada por hífen ou não, como xixi, mimi, lero-lero e mata-mata
pub fn palavra_duplicada(palavra: String) -> Bool {
  case string.slice(palavra, string.length(palavra)/2, 1) == "-" {
    True -> string.slice(palavra, 0, string.length(palavra)/2) == string.slice(palavra, string.length(palavra)/2 + 1, string.length(palavra)/2)
    False -> case string.length(palavra) == 1 {
      True -> False
      False -> string.slice(palavra, 0, string.length(palavra)/2) == string.slice(palavra, string.length(palavra)/2, string.length(palavra)/2)
    }
  }
}

pub fn palavra_duplicada_examples() {
  check.eq(palavra_duplicada("xixi"), True)
  check.eq(palavra_duplicada("lero-lero"), True)
  check.eq(palavra_duplicada("a"), False)
  check.eq(palavra_duplicada("aa"), True)
  check.eq(palavra_duplicada("aba"), False)
}

/// Exercício 26
/// Calcula a quantidade de azulejos necessários para azulejar um parede
/// de *altura* altura e *comprimento* largura (em metros), sendo que azulejo é um quadrado
/// com 20 centímetros de lado
pub fn quantos_azulejos(comprimento: Float, altura: Float) -> Int {
  float.round({{comprimento *. 10.0} *. {altura *. 10.0}} /. {2.0 *. 2.0})
}

pub fn quantos_azulejos_examples() {
  check.eq(quantos_azulejos(0.8, 0.8), 16)
  check.eq(quantos_azulejos(0.4, 0.4), 4)
  check.eq(quantos_azulejos(1.5, 3.0), 113)
}

/// Exercício 27
/// Rotaciona uma *string* *n* posições para a direita, ou seja,
/// os últimos *n* caracteres da *string* vão para as primeiras
/// *n* posições, empurrando os outros caracteres que estavam naquela posição pra frente
pub fn rotaciona_string(string: String, n: Int) -> String {
  string.slice(string, string.length(string) - n, n) <> string.slice(string, 0, string.length(string) - n)
}

pub fn rotaciona_string_examples() {
  check.eq(rotaciona_string("marcelio", 0), "marcelio")
  check.eq(rotaciona_string("marcelio", 1), "omarceli")
  check.eq(rotaciona_string("marcelio", 2), "iomarcel")
  check.eq(rotaciona_string("marcelio", 3), "liomarce")
  check.eq(rotaciona_string("marcelio", 4), "eliomarc")
  check.eq(rotaciona_string("marcelio", 5), "celiomar")
  check.eq(rotaciona_string("marcelio", 6), "rcelioma")
  check.eq(rotaciona_string("marcelio", 7), "arceliom")
  check.eq(rotaciona_string("marcelio", 8), "marcelio")
}

/// Exercício 28
/// Adiciona o dígito 9 no começo dos números de *celular* que não o
/// possuam, os números possuem o formato de DDD entre parênteses e 
/// o número separado por hífen como o seguinte: (44) 9910-1122
pub fn add_nove(celular: String) -> String {
  case string.length(celular) == 14 {
    True -> string.slice(celular, 0, 5) <> "9" <> string.slice(celular, 5, string.length(celular) - 5)
    False -> celular
  }
}

pub fn add_nove_examples() {
  check.eq(add_nove("(44) 9910-1122"), "(44) 99910-1122")
  check.eq(add_nove("(44) 99910-1122"), "(44) 99910-1122")
}

/// Exercício 29
/// Devolva a parte da *mensagem* que deve estar aparecendo no em um *momento*
/// de um determinado letreiro que suporta um determinado *numero_char* de caracteres
/// e a mensagem continua repetindo infinitamente após ela terminar
pub fn mensagem_letreiro(mensagem: String, momento: Int, numero_char: Int) -> String {
  case string.length(mensagem) - numero_char < momento {
    True -> string.slice(mensagem, momento, numero_char) <> " " <> string.slice(mensagem, 0, momento - {string.length(mensagem) - numero_char} - 1)
    False -> string.slice(mensagem, momento, numero_char)
  }
}

pub fn mensagem_letreiro_examples() {
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 0, 20), "Promocao de sorvetes")
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 1, 20), "romocao de sorvetes,")
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 2, 20), "omocao de sorvetes, ")
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 17, 20), "tes, pague 2 leve 3!")
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 18, 20), "es, pague 2 leve 3! ")
  check.eq(mensagem_letreiro("Promocao de sorvetes, pague 2 leve 3!", 19, 20), "s, pague 2 leve 3! P")
}

/// Exercício 30 (Desafio) - Primeira parte
/// Verifica se um *numero* inteiro  de 4 digitos é um palíndromo
pub fn numero_palindromo(numero: Int) -> Bool {
  string.slice(int.to_string(numero), 0, 1) == string.slice(int.to_string(numero), 3, 1) && string.slice(int.to_string(numero), 1, 1) == string.slice(int.to_string(numero), 2, 1)
}

pub fn numero_palindromo_examples() {
  check.eq(numero_palindromo(9119), True)
  check.eq(numero_palindromo(9219), False)
}



pub fn main() {
  io.println("Hello World!")
}
