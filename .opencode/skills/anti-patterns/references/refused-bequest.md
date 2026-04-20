# Refused Bequest (Herança Recusada)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 059

## O que é

Subclasse que herda métodos e dados da classe pai mas não usa ou não quer parte deles. A subclasse "recusa" a herança, indicando que a hierarquia de herança está errada ou que deveria usar composição em vez de herança.

## Sintomas

- Subclasse sobrescreve métodos do pai para lançar `throw new Error('Not supported')`
- Métodos herdados que nunca são chamados na subclasse (60%+ não usados)
- Necessidade de checar `instanceof` para saber o que o objeto suporta
- Subclasse que herda por "reutilizar código" mas não por ser do mesmo tipo
- Implementações vazias (`pass`) ou stubs para métodos herdados que não fazem sentido

## ❌ Exemplo (violação)

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

## ✅ Refatoração

```javascript
// ✅ Composição: ReadOnlyList não herda, usa
class ReadOnlyList {
  #items;
  constructor(items) { this.#items = [...items]; }
  get(index) { return this.#items[index]; }
  get length() { return this.#items.length; }
}

// Se precisar de comportamento comum: extrair para helper/mixin
const listBehavior = { iterate() { ... }, map() { ... } };
```

## Codetag sugerida

```typescript
// FIXME: Refused Bequest — ReadOnlyList herda de List mas recusa add/remove
// TODO: Replace Inheritance with Composition — criar ReadOnlyList independente
```
