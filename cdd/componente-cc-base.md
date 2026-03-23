---
titulo: CC_base — Complexidade Ciclomática como Componente ICP
aliases:
  - CC_base
  - Complexidade Ciclomática
  - Cyclomatic Complexity
tipo: conceito
origem: cdd
tags:
  - cdd
  - icp
  - complexidade-ciclomatica
  - cc
relacionados:
  - "[[calculo-icp]]"
  - "[[componente-aninhamento]]"
  - "[[componente-responsabilidades]]"
  - "[[priorizacao-simplicidade-clareza]]"
criado: 2026-03-23
---

# CC_base — Complexidade Ciclomática como Componente ICP

*Cyclomatic Complexity — Thomas McCabe (1976)*

---

## Definição

**CC_base** é o primeiro componente do ICP. Mede o número de **caminhos independentes de execução** dentro de uma função ou método — ou seja, quantas vezes o fluxo do programa pode se bifurcar.

Foi introduzida por Thomas McCabe em 1976 como métrica estrutural de software. No CDD, a CC bruta é convertida em uma escala de 1 a 5 para compor o ICP.

## Como Calcular

```
CC = número de pontos de decisão + 1
```

**Pontos de decisão** são estruturas que criam uma bifurcação no fluxo de execução:

| Estrutura | Incremento |
|---|---|
| `if` | +1 |
| `else if` | +1 |
| `for`, `while`, `do-while` | +1 |
| `case` em `switch` | +1 |
| `&&` ou `\|\|` em condições | +1 |
| `catch` em `try-catch` | +1 |
| `?` (operador ternário) | +1 |

## Conversão para ICP CC_base

| CC | ICP CC_base | Categoria |
|----|-------------|-----------|
| ≤ 5 | 1 | Simples |
| 6–10 | 2 | Moderado |
| 11–15 | 3 | Complexo |
| 16–20 | 4 | Muito Complexo |
| > 20 | 5 | Crítico |

**Nota:** O ICP CC_base mínimo é 1, não 0, pois toda função tem pelo menos 1 caminho de execução.

## Exemplos

### CC = 1 → ICP CC_base = 1

```javascript
// Sem pontos de decisão: CC = 0 + 1 = 1
function add(a, b) {
  return a + b;
}
```

### CC = 4 → ICP CC_base = 1

```javascript
// 3 pontos de decisão: CC = 3 + 1 = 4
function validateEmail(email) {
  if (!email) return false;           // +1
  if (!email.includes('@')) return false; // +1
  if (email.length < 5) return false; // +1
  return true;
}
```

### CC = 6 → ICP CC_base = 2

```javascript
// 5 pontos de decisão: CC = 5 + 1 = 6
function getShippingCost(order) {
  if (!order.address) return null;    // +1
  if (order.total > 200) return 0;   // +1

  const base = order.isExpress       // +1 (ternário)
    ? 25
    : order.weight > 5               // +1 (ternário aninhado)
      ? 15
      : 10;

  return order.isInternational       // +1 (ternário)
    ? base * 2.5
    : base;
}
```

### CC = 11 → ICP CC_base = 3

```javascript
// 10 pontos de decisão: CC = 10 + 1 = 11
function processOrder(order) {
  if (!order) return null;           // +1
  if (!order.items.length) return false; // +1
  if (!order.customer) return false; // +1

  let total = 0;
  for (const item of order.items) { // +1
    if (item.inStock) {              // +1
      if (item.discount > 0) {       // +1
        total += item.price * (1 - item.discount); // +1 (&&)
      } else {
        total += item.price;
      }
    }
  }

  if (order.coupon && order.coupon.valid) { // +2 (if + &&)
    total *= (1 - order.coupon.discount);
  }

  return total > 0 ? total : false;  // +1
}
```

## Impacto Cognitivo da CC Alta

Alta CC significa que o desenvolvedor precisa rastrear mentalmente múltiplas ramificações para entender o comportamento completo da função:

- CC = 5: 5 cenários de teste diferentes mínimos
- CC = 10: 10 cenários — o desenvolvedor raramente consegue visualizar todos
- CC = 20+: impossível manter o modelo mental completo na memória de trabalho

## Como Reduzir CC_base

### Estratégia 1 — Extrair Método

Mova um bloco de condições para uma função com nome expressivo:

```javascript
// Antes: CC = 6
function canApplyDiscount(user, order) {
  return user.isPremium               // +1 (&&)
    && user.purchases > 10           // +1 (&&)
    && order.total > 50              // +1 (&&)
    && !order.hasActivePromotion;    // +1 (&&)
}

// Depois: CC = 2 no método principal
function processOrder(order, user) {
  if (!canApplyDiscount(user, order)) return order.total; // +1
  return applyDiscount(order.total);
}

// CC = 4 — isolada e testável independentemente
function canApplyDiscount(user, order) { ... }
```

### Estratégia 2 — Guard Clauses

Substitua `if-else` aninhados por retornos antecipados:

```javascript
// Antes: CC = 4 com else aninhado
function getUser(id) {
  if (id) {
    const user = db.find(id);
    if (user) {
      if (user.active) {
        return user;
      }
    }
  }
  return null;
}

// Depois: CC = 4, mas linearizado — mais fácil de ler
function getUser(id) {
  if (!id) return null;
  const user = db.find(id);
  if (!user) return null;
  if (!user.active) return null;
  return user;
}
```

### Estratégia 3 — Tabela de Dados

Substitua `switch/if-else` longos por um mapa de dados:

```javascript
// Antes: CC = 5 (4 cases + 1)
function getStatusLabel(status) {
  switch (status) {
    case 'pending': return 'Aguardando';
    case 'active': return 'Ativo';
    case 'suspended': return 'Suspenso';
    case 'closed': return 'Encerrado';
    default: return 'Desconhecido';
  }
}

// Depois: CC = 2
const STATUS_LABELS = {
  pending: 'Aguardando',
  active: 'Ativo',
  suspended: 'Suspenso',
  closed: 'Encerrado',
};

function getStatusLabel(status) {
  return STATUS_LABELS[status] ?? 'Desconhecido'; // +1 (??)
}
```

## Detecção Automática

Biome: [`noExcessiveCognitiveComplexity`](https://biomejs.dev/linter/rules/no-excessive-cognitive-complexity/) detecta funções com CC elevada e permite configurar o limite via `maxAllowedComplexity`.

## Relacionados

- [[calculo-icp]] — CC_base é o primeiro componente do ICP total
- [[componente-aninhamento]] — frequentemente correlacionado com CC alta
- [[priorizacao-simplicidade-clareza]] — rule que limita CC ≤ 5 por método
- [[conformidade-principio-inversao-consulta]] — separar Queries de Commands reduz CC
