---
titulo: Accidental Mutation (Mutação Acidental)
aliases:
  - Accidental Mutation
  - Mutação Acidental
  - Parameter Mutation
tipo: anti-pattern
severidade: 🟠 Alto
origem: clean-code
tags: [anti-pattern, imutabilidade, efeitos-colaterais, parametros]
criado: 2026-03-23
relacionados:
  - "[[imutabilidade-objetos-freeze]]"
  - "[[restricao-funcoes-efeitos-colaterais]]"
  - "[[shared-mutable-state]]"
---

# Accidental Mutation (Mutação Acidental)

*Accidental Mutation / Parameter Mutation*

---

## Definição

Uma função recebe um objeto ou array como parâmetro e o **modifica diretamente**, sem que o chamador espere ou queira essa alteração. O efeito colateral é invisível na assinatura da função — o nome sugere uma operação de leitura ou transformação, mas o estado original é alterado silenciosamente.

## Sintomas

- Função nomeada como `getX`, `filterX` ou `calculateX` que também modifica o parâmetro
- Bugs que aparecem somente após chamar uma função específica, mesmo que o resultado dela seja descartado
- Arrays que mudam de ordem inesperadamente após passar por uma função
- Objetos que têm propriedades alteradas sem o módulo chamador ter explicitamente feito isso

## Causas Raiz

- Desconhecimento de que JavaScript passa objetos e arrays **por referência** — não por valor
- Uso de métodos mutantes (`Array.sort`, `Array.splice`, `Array.reverse`) sem saber que operam in-place
- Otimização prematura — evitar a cópia para "economizar memória" sem medir o impacto real
- Migração de código de linguagens que passam por valor (como Java com primitivos)

## Consequências

- **Violação do Princípio da Menor Surpresa**: o chamador recebe de volta um objeto diferente do que passou
- **Testes dependentes de ordem**: o estado do parâmetro depois de um teste afeta o próximo
- **Rastreabilidade de bugs prejudicada**: a mutação acontece dentro de uma função que não deveria ter efeitos colaterais
- **Quebra de imutabilidade de domínio**: Entities e Value Objects podem ter seu estado corrompido

## A Armadilha do `Array.sort`

O caso mais comum e traiçoeiro:

```javascript
// ❌ .sort() opera in-place — modifica o array original
function getTopUsers(users) {
  return users
    .sort((a, b) => b.score - a.score) // MUTA users!
    .slice(0, 5);
}

const users = [{ name: 'Alice', score: 80 }, { name: 'Bob', score: 95 }];
const top = getTopUsers(users);

console.log(users); // [Bob, Alice] — ordem original destruída
```

Outros métodos mutantes comuns: `push`, `pop`, `shift`, `unshift`, `splice`, `reverse`, `fill`.

## Solução / Refatoração

### 1 — Clonar o parâmetro antes de modificar

```javascript
// ✅ Cópia shallow com spread — preserva o array original
function getTopUsers(users) {
  return [...users]
    .sort((a, b) => b.score - a.score)
    .slice(0, 5);
}

// ✅ Para objetos com propriedades simples
function deactivate(user) {
  return { ...user, active: false }; // retorna novo objeto, não muta o original
}
```

### 2 — `structuredClone` para deep copy

```javascript
// ✅ Clonagem profunda nativa (Node 17+, browsers modernos)
function processOrder(order) {
  const copy = structuredClone(order); // clone profundo sem dependências
  copy.items.forEach(item => { item.shipped = true; });
  return copy;
}
```

### 3 — Usar métodos não-mutantes

```javascript
// Preferir equivalentes funcionais que retornam novos arrays/objetos:
const sorted  = [...arr].sort(...);     // em vez de arr.sort(...)
const without = arr.filter(x => x.id !== id); // em vez de arr.splice(...)
const added   = [...arr, newItem];      // em vez de arr.push(newItem)
const updated = arr.map(x =>            // em vez de x.value = y
  x.id === id ? { ...x, value: y } : x
);
```

### 4 — `Object.freeze` para garantir na origem

```javascript
// Congelar o parâmetro logo no início sinaliza que ele não deve ser mutado
// e lança TypeError se algum código tentar mutar
function processItems(items) {
  Object.freeze(items); // se algo mutar items aqui dentro, falha rápido
  return items.filter(i => i.active).map(transform);
}
```

## Exemplo — Problemático

```javascript
// ❌ "Filtra" usuários mas muta o objeto original com efeito colateral
function filterAndLog(users) {
  const active = users.filter(u => u.active);
  users.forEach(u => { u.checked = true; }); // efeito colateral oculto!
  return active;
}

const users = [{ name: 'Alice', active: true }, { name: 'Bob', active: false }];
const result = filterAndLog(users);

console.log(users[0].checked); // true — o caller não sabia disso
```

## Exemplo — Refatorado

```javascript
// ✅ Pura: retorna nova lista e novo estado — zero efeitos colaterais
function filterActive(users) {
  return users.filter(u => u.active); // não toca no array original
}

// Efeito colateral explícito e separado, com nome que revela a intenção
function markAllAsChecked(users) {
  return users.map(u => ({ ...u, checked: true })); // retorna novos objetos
}

const active = filterActive(users);
const checked = markAllAsChecked(users);
```

## Rules que Previnem

- [[imutabilidade-objetos-freeze]] — congela objetos de domínio antes de expô-los
- [[restricao-funcoes-efeitos-colaterais]] — exige que funções Query não modifiquem estado externo
- [[conformidade-principio-inversao-consulta]] — separa Commands (que mutam) de Queries (que não mutam)

## Relacionados

- [[shared-mutable-state]] — Accidental Mutation é a causa mais comum de Shared Mutable State
- [[restricao-funcoes-efeitos-colaterais]] — o princípio que esta violação quebra
- [[clever-code]] — código "esperto" que modifica in-place para economizar linhas
