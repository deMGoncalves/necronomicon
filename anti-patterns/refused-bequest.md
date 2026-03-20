---
titulo: Refused Bequest (Herança Recusada)
aliases:
  - Refused Bequest
  - Herança Recusada
tipo: anti-pattern
id: AP-18
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, heranca, polimorfismo]
criado: 2026-03-20
relacionados:
  - "[[large-class]]"
  - "[[001_single-responsibility-principle]]"
  - "[[003_liskov-substitution-principle]]"
---

# Refused Bequest (Herança Recusada)

*Refused Bequest*

---

## Definição

Subclasse que herda métodos e dados da classe pai mas não usa ou não quer parte deles. A subclasse "recusa" a herança. Indica que a hierarquia de herança está errada.

## Sintomas

- Subclasse sobrescreve métodos do pai para lançar `throw new Error('Not supported')`
- Métodos herdados que nunca são chamados na subclasse
- Necessidade de checar `instanceof` para saber o que o objeto suporta
- Subclasse que herda por "reutilizar código" mas não por ser do mesmo tipo

## Causas Raiz

- Herança usada como mecanismo de reutilização de código em vez de modelagem de tipo
- Hierarquia criada prematuramente sem entender as variações reais
- "Copiar comportamento" confundido com "ser do mesmo tipo"

## Consequências

- Violação do LSP: subclasse não pode substituir o pai sem surpresas
- Interface poluída: objetos expõem métodos que não funcionam
- Comportamento inesperado: código que usa a classe base assume comportamentos que a subclasse não suporta

## Solução / Refatoração

Se a subclasse não quer parte da interface do pai: usar **composição em vez de herança**. Extrair o comportamento comum para um objeto reutilizável e injetá-lo onde necessário.

## Exemplo — Problemático

```javascript
// ❌ ReadOnlyList herda de List mas recusa os métodos de escrita
class List {
  add(item) { this.items.push(item); }
  remove(item) { ... }
  get(index) { return this.items[index]; }
}

class ReadOnlyList extends List {
  add() { throw new Error('Read-only list!'); }    // recusa a herança
  remove() { throw new Error('Read-only list!'); } // recusa a herança
}
```

## Exemplo — Refatorado

```javascript
// ✅ Composição: ReadOnlyList não herda, usa
class ReadOnlyList {
  #items;
  constructor(items) { this.#items = [...items]; }
  get(index) { return this.#items[index]; }
  get length() { return this.#items.length; }
}
```

## Rules que Previnem

- [[003_liskov-substitution-principle]] — LSP: subclasse deve ser substituível pelo pai

## Relacionados

- [[poltergeists]] — subclasses fantasmas que herdam tudo e usam quase nada
