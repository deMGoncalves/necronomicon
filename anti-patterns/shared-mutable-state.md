---
titulo: Shared Mutable State (Estado Mutável Compartilhado)
aliases:
  - Shared Mutable State
  - Estado Mutável Compartilhado
  - Global Mutable State
tipo: anti-pattern
severidade: 🟠 Alto
origem: clean-code
tags: [anti-pattern, imutabilidade, estado, efeitos-colaterais]
criado: 2026-03-23
relacionados:
  - "[[imutabilidade-objetos-freeze]]"
  - "[[restricao-funcoes-efeitos-colaterais]]"
  - "[[accidental-mutation]]"
---

# Shared Mutable State (Estado Mutável Compartilhado)

*Shared Mutable State / Global Mutable State*

---

## Definição

Múltiplos módulos, funções ou threads leem e **modificam o mesmo objeto** sem coordenação explícita. Qualquer parte do sistema pode alterar o estado a qualquer momento, tornando o comportamento do programa imprevisível e difícil de rastrear.

## Sintomas

- Objetos de domínio passados por referência e modificados em vários pontos
- Variáveis globais ou de módulo alteradas por múltiplas funções
- Bugs que surgem longe do ponto de modificação — difícil identificar quem mutou
- Testes que falham dependendo da ordem de execução
- Comportamento diferente entre a primeira e a segunda chamada da mesma função

## Causas Raiz

- Passar objetos por referência sem consciência de que JS/TS compartilha a referência
- Usar arrays e objetos como "buffers" de comunicação entre partes do sistema
- Performance prematura — evitar cópias sem medir se o custo é real

## Consequências

- **Bugs fantasmas**: a origem da mutação está em um módulo diferente do ponto de falha
- **Testes frágeis**: o resultado depende do estado global deixado pelo teste anterior
- **Concorrência impossível**: qualquer paralelismo introduz race conditions
- **Rastreabilidade zero**: impossível saber quem alterou o estado sem breakpoints

## Solução / Refatoração

### 1 — Imutabilidade com `Object.freeze`

```javascript
// ❌ Objeto mutável compartilhado entre módulos
const config = { timeout: 3000, retries: 3 };
moduleA.init(config); // moduleA pode fazer config.timeout = 9999
moduleB.init(config); // agora recebe timeout = 9999, sem saber

// ✅ Congelar antes de compartilhar
const config = Object.freeze({ timeout: 3000, retries: 3 });
moduleA.init(config); // qualquer tentativa de mutação lança TypeError
moduleB.init(config); // sempre recebe os valores originais
```

### 2 — Clonar antes de modificar

```javascript
// ❌ Modifica o array original recebido como parâmetro
function sortUsers(users) {
  return users.sort((a, b) => a.name.localeCompare(b.name)); // .sort() muta in-place
}

// ✅ Trabalha em uma cópia — o caller mantém a ordem original
function sortUsers(users) {
  return [...users].sort((a, b) => a.name.localeCompare(b.name));
}
```

### 3 — Deep Freeze para objetos aninhados

```javascript
function deepFreeze(obj) {
  Object.getOwnPropertyNames(obj).forEach(name => {
    const value = obj[name];
    if (value && typeof value === 'object') deepFreeze(value);
  });
  return Object.freeze(obj);
}

const order = deepFreeze({
  id: 1,
  customer: { name: 'Alice', address: { city: 'SP' } }
});

order.customer.address.city = 'RJ'; // ❌ TypeError — protegido em todos os níveis
```

### 4 — `readonly` no TypeScript

```typescript
// Compiler bloqueia mutações em tempo de compilação
interface Config {
  readonly timeout: number;
  readonly retries: number;
}

function init(config: Readonly<Config>) {
  config.timeout = 9999; // ❌ Erro de compilação
}
```

## Exemplo — Problemático

```javascript
// ❌ Estado de carrinho compartilhado e mutável
const cart = { items: [], total: 0 };

function addItem(item) {
  cart.items.push(item);        // muta o array global
  cart.total += item.price;     // muta a propriedade global
}

function applyDiscount(percent) {
  cart.total = cart.total * (1 - percent); // muta novamente
}

// Quem é responsável por cart.total agora? Ninguém sabe ao certo.
```

## Exemplo — Refatorado

```javascript
// ✅ Estado imutável — cada transformação retorna um novo objeto
function addItem(cart, item) {
  return Object.freeze({
    items: [...cart.items, item],
    total: cart.total + item.price,
  });
}

function applyDiscount(cart, percent) {
  return Object.freeze({
    ...cart,
    total: cart.total * (1 - percent),
  });
}

// Cada módulo recebe e retorna versões imutáveis — rastreável e testável
const cart1 = addItem(emptyCart, item);
const cart2 = applyDiscount(cart1, 0.1);
```

## Rules que Previnem

- [[imutabilidade-objetos-freeze]] — exige `Object.freeze()` em Value Objects e Entities
- [[restricao-funcoes-efeitos-colaterais]] — proíbe funções Query que modificam estado externo

## Relacionados

- [[accidental-mutation]] — caso específico: mutação acidental de parâmetro recebido
- [[restricao-funcoes-efeitos-colaterais]] — efeitos colaterais ocultos são a consequência direta
- [[conformidade-principio-inversao-consulta]] — Queries que mutam estado são Shared Mutable State disfarçado
