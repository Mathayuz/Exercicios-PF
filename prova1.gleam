import gleam/string
import sgleam/check

/// O estado de um editor de linha
/// - esquerda é o conteúdo da linha a esquerda do cursor
/// - direita é o conteúdo da linha a direita do cursor
pub type Editor {
  Editor(esquerda: String, direita: String)
}

/// Exercício 1 letra a)
/// O comando que um editor de linha pode receber.
pub type Comando {
  // Move o cursor um caractere para a direita.
  MoverDireita
  // Move o cursor um caractere para a esquerda.
  MoverEsquerda
  // Apaga o caractere anterior ao cursor.
  Backspace
  // Insere o caractere *c* na posição do cursor.
  InserirCaractere(c: String)
}

/// Exercício 1 letra b)
/// Atualiza o *estado* do editor com base no *comando* requisitado para ser executado.
pub fn atualiza_editor(estado: Editor, comando: Comando) -> Editor {
  case comando {
    MoverDireita ->
      Editor(
        estado.esquerda <> string.slice(estado.direita, 0, 1),
        string.slice(estado.direita, 1, string.length(estado.direita) - 1),
      )
    MoverEsquerda ->
      Editor(
        string.slice(estado.esquerda, 0, string.length(estado.esquerda) - 1),
        string.slice(estado.esquerda, string.length(estado.esquerda) - 1, 1)
          <> estado.direita,
      )
    Backspace ->
      Editor(
        string.slice(estado.esquerda, 0, string.length(estado.esquerda) - 1),
        estado.direita,
      )
    InserirCaractere(c) -> Editor(estado.esquerda <> c, estado.direita)
  }
}

pub fn atualiza_editor_examples() {
  check.eq(
    atualiza_editor(Editor("", "Teste 1 do Backspace"), Backspace),
    Editor("", "Teste 1 do Backspace"),
  )
  check.eq(
    atualiza_editor(Editor("Teste 2 do Backspace", ""), Backspace),
    Editor("Teste 2 do Backspac", ""),
  )
  check.eq(
    atualiza_editor(
      Editor("", "este 1 do InserirCaractere"),
      InserirCaractere("T"),
    ),
    Editor("T", "este 1 do InserirCaractere"),
  )
  check.eq(
    atualiza_editor(
      Editor("Teste 2 do InserirCaracter", ""),
      InserirCaractere("e"),
    ),
    Editor("Teste 2 do InserirCaractere", ""),
  )
  check.eq(
    atualiza_editor(Editor("Teste do MoverDireita", ""), MoverDireita),
    Editor("Teste do MoverDireita", ""),
  )
  check.eq(
    atualiza_editor(Editor("", "Teste do MoverEsquerda"), MoverEsquerda),
    Editor("", "Teste do MoverEsquerda"),
  )
  check.eq(
    atualiza_editor(Editor("Exempl", " de teste"), InserirCaractere("o")),
    Editor("Exemplo", " de teste"),
  )
  check.eq(
    atualiza_editor(Editor("Exempl", " de teste"), Backspace),
    Editor("Exemp", " de teste"),
  )
  check.eq(
    atualiza_editor(Editor("Exempl", " de teste"), MoverDireita),
    Editor("Exempl ", "de teste"),
  )
  check.eq(
    atualiza_editor(Editor("Exempl", " de teste"), MoverEsquerda),
    Editor("Exemp", "l de teste"),
  )
}

/// Exercício 2 letra a)
/// Devolve a quantidade de vezes que um *numero* aparece em uma *lista*.
pub fn conta_numero(lista: List(Int), numero: Int) -> Int {
  case lista {
    [] -> 0
    [unico] ->
      case numero == unico {
        True -> 1
        False -> 0
      }
    [primeiro, ..resto] ->
      case primeiro == numero {
        True -> 1 + conta_numero(resto, numero)
        False -> conta_numero(resto, numero)
      }
  }
}

pub fn conta_numero_examples() {
  check.eq(conta_numero([], 1), 0)
  check.eq(conta_numero([1], 1), 1)
  check.eq(conta_numero([2], 1), 0)
  check.eq(conta_numero([1, 2], 1), 1)
  check.eq(conta_numero([2, 1], 1), 1)
  check.eq(conta_numero([2, 1, 2], 3), 0)
  check.eq(conta_numero([1, 2, 1], 1), 2)
  check.eq(conta_numero([2, 1, 2, 1, 3], 2), 2)
  check.eq(conta_numero([2, 1, 2, 3, 4, 2], 2), 3)
  check.eq(conta_numero([3, 2, 1, 1, 2, 3], 1), 2)
}

/// Exercício 2 letra b)
/// Devolve a máxima repetição de uma lista de números.
/// A máxima repetição em uma lista é a maior quantidade de vezes 
/// que qualquer elemento da lista se repete.
pub fn maxima_repeticao(lst: List(Int)) -> Int {
  case lst {
    [] -> 0
    [_] -> 1
    [primeiro, ..resto] ->
      case conta_numero(lst, primeiro) > maxima_repeticao(resto) {
        True -> conta_numero(lst, primeiro)
        False -> maxima_repeticao(resto)
      }
  }
}

pub fn maxima_repeticao_examples() {
  check.eq(maxima_repeticao([]), 0)
  check.eq(maxima_repeticao([1]), 1)
  check.eq(maxima_repeticao([1, 2]), 1)
  check.eq(maxima_repeticao([2, 2]), 2)
  check.eq(maxima_repeticao([2, 1, 3]), 1)
  check.eq(maxima_repeticao([1, 2, 1]), 2)
  check.eq(maxima_repeticao([2, 2, 3, 2, 3]), 3)
  check.eq(maxima_repeticao([2, 2, 2, 3, 3, 3]), 3)
  check.eq(maxima_repeticao([4, 1, 3, -1, 8, -1, -1]), 3)
  check.eq(maxima_repeticao([3, 5, 1, 3, 4, 5, 1]), 2)
}
