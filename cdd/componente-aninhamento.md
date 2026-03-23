---
titulo: Aninhamento — Profundidade de Indentação como Componente ICP
aliases:
  - Aninhamento
  - Nesting
  - Profundidade de Indentação
tipo: conceito
origem: cdd
tags:
  - cdd
  - icp
  - aninhamento
  - indentacao
  - guard-clause
relacionados:
  - "[[calculo-icp]]"
  - "[[componente-cc-base]]"
  - "[[componente-responsabilidades]]"
criado: 2026-03-23
---

# Aninhamento — Profundidade de Indentação como Componente ICP

*Nesting Depth*

---

## Definição

**Aninhamento** é o segundo componente do ICP. Mede a **profundidade máxima de indentação** que o código atinge em uma função ou método — quantos níveis de estruturas de controle estão aninhados uns dentro dos outros.

O aninhamento é um indicador direto de carga cognitiva porque o desenvolvedor precisa manter na memória de trabalho o **contexto acumulado** de cada nível acima: as condições que permitiram chegar até aquele ponto.

## Como Calcular

Contar o número máximo de níveis de blocos aninhados (independentemente de CC):

```javascript
function example(a, b, c) {  // Nível 0
  if (a) {                   // Nível 1
    for (const x of b) {     // Nível 2
      if (x.valid) {         // Nível 3
        // código aqui       // Nível 3
      }
    }
  }
}
// Profundidade máxima = 3 níveis → +2 pontos de ICP
```

## Tabela de Pontuação

| Profundidade máxima | Pontos ICP | Exemplo |
|---------------------|------------|---------|
| 1 nível | 0 | Código linear com guard clauses |
| 2 níveis | 1 | Um bloco `if` ou `for` dentro da função |
| 3 níveis | 2 | `if` dentro de `for` |
| 4+ níveis | 3 | Pyramid of Doom — aninhamento crítico |

## Exemplos

### 1 nível → +0 ICP (Guard Clauses)

```javascript
// Leitura linear: cada condição é processada isoladamente
function createOrder(user, items) {
  if (!user) throw new UserRequiredError();     // Nível 1
  if (!items.length) throw new EmptyCartError(); // Nível 1
  if (!user.hasPaymentMethod) throw new PaymentMethodError(); // Nível 1

  return orderRepository.create({ user, items });
}
```

### 2 níveis → +1 ICP (Aceitável)

```javascript
function processActiveItems(items) {
  const results = [];
  for (const item of items) {   // Nível 1
    if (item.isActive) {        // Nível 2
      results.push(transform(item));
    }
  }
  return results;
}
```

### 3 níveis → +2 ICP (Preocupante)

```javascript
// O desenvolvedor precisa manter 3 contextos simultaneamente:
// 1. "estamos dentro do for" (iterando orders)
// 2. "estamos dentro do if order.isPaid"
// 3. "estamos dentro do for order.items"
function getShippedItems(orders) {
  const result = [];
  for (const order of orders) {       // Nível 1
    if (order.isPaid) {               // Nível 2
      for (const item of order.items) { // Nível 3
        result.push(item);
      }
    }
  }
  return result;
}
```

### 4+ níveis → +3 ICP (Pyramid of Doom)

```javascript
// Anti-pattern: Pyramid of Doom
// Cada nível adiciona um contexto que precisa ser rastreado até o fim
function syncData(userId) {
  if (userId) {                           // Nível 1
    const user = db.find(userId);
    if (user) {                           // Nível 2
      if (user.needsSync) {              // Nível 3
        const data = api.fetch(user.id);
        if (data) {                       // Nível 4
          for (const item of data) {      // Nível 5 — crítico
            user.update(item);
          }
        }
      }
    }
  }
}
```

## Por que o Aninhamento é Tão Custoso Cognitivamente

Cada nível de aninhamento impõe uma **condição que o desenvolvedor precisa manter na pilha mental**. No exemplo de 4 níveis acima, ao chegar no `for` interno, o desenvolvedor precisa lembrar simultaneamente:

1. "userId existe" (nível 1)
2. "user existe no banco" (nível 2)
3. "user.needsSync é true" (nível 3)
4. "data foi retornado pela API" (nível 4)

Isso consome 4 dos 7±2 slots disponíveis na memória de trabalho — antes de sequer processar a lógica do `for`.

## Como Reduzir Aninhamento

### Guard Clauses (Inversão de Condição)

A técnica mais eficaz: inverter cada condição e retornar antecipadamente, linearizando o código.

```javascript
// Antes: 4 níveis de aninhamento → +3 ICP
function syncData(userId) {
  if (userId) {
    const user = db.find(userId);
    if (user) {
      if (user.needsSync) {
        const data = api.fetch(user.id);
        if (data) {
          for (const item of data) {
            user.update(item);
          }
        }
      }
    }
  }
}

// Depois: 1-2 níveis → +0/1 ICP
function syncData(userId) {
  if (!userId) return;
  const user = db.find(userId);
  if (!user || !user.needsSync) return;
  const data = api.fetch(user.id);
  if (!data) return;

  for (const item of data) {  // Nível 1
    user.update(item);
  }
}
```

### Extração de Método

Mova blocos aninhados para funções com nomes expressivos:

```javascript
// Antes: 3 níveis
function processOrders(orders) {
  const results = [];
  for (const order of orders) {
    if (order.isPaid) {
      for (const item of order.items) {
        results.push(ship(item));
      }
    }
  }
  return results;
}

// Depois: 1 nível em cada função
function processOrders(orders) {
  return orders
    .filter(order => order.isPaid)
    .flatMap(order => shipOrderItems(order));
}

function shipOrderItems(order) {
  return order.items.map(item => ship(item)); // Nível 1
}
```

## Relação com CC_base

Aninhamento e CC_base são **correlacionados mas independentes**:

- Código com CC alta e aninhamento baixo (guard clauses) é mais legível que código com CC igual e aninhamento alto
- O ICP captura essa diferença aditivamente: ambos contribuem, permitindo que refatorações que reduzem aninhamento (sem reduzir CC) sejam reconhecidas como melhorias reais

## Detecção Automática

Biome: [`noExcessiveCognitiveComplexity`](https://biomejs.dev/linter/rules/no-excessive-cognitive-complexity/) detecta aninhamento excessivo como parte da complexidade cognitiva total.

## Relacionados

- [[calculo-icp]] — Aninhamento é o segundo componente do ICP
- [[componente-cc-base]] — frequentemente aumenta junto com aninhamento
- [[priorizacao-simplicidade-clareza]] — KISS restringe aninhamento indiretamente
- [[anti-patterns/pyramid-of-doom|Pyramid of Doom]] — anti-pattern de aninhamento extremo
