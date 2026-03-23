---
titulo: Cálculo de ICP (Intrinsic Complexity Points)
aliases:
  - ICP
  - Intrinsic Complexity Points
  - Cálculo ICP
tipo: conceito
origem: cdd
tags:
  - cdd
  - icp
  - complexidade-cognitiva
  - metrica
relacionados:
  - "[[componente-cc-base]]"
  - "[[componente-aninhamento]]"
  - "[[componente-responsabilidades]]"
  - "[[componente-acoplamento]]"
  - "[[metodologia-cdd]]"
criado: 2026-03-23
---

# Cálculo de ICP (Intrinsic Complexity Points)

*ICP — Intrinsic Complexity Points*

---

## Definição

ICP (Intrinsic Complexity Points) é a métrica central do CDD que **quantifica a carga cognitiva intrínseca** de uma unidade de código. Combina quatro dimensões independentes de complexidade em um número único e objetivo.

## Fórmula

```
ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento
```

Cada componente contribui com pontos adicionais ao ICP total. O objetivo é manter o ICP o mais baixo possível, com ≤ 5 como meta e ≤ 10 como limite absoluto.

## Componentes

| Componente | O que mede | Arquivo detalhado |
|---|---|---|
| [[componente-cc-base\|CC_base]] | Caminhos independentes de execução | `componente-cc-base.md` |
| [[componente-aninhamento\|Aninhamento]] | Profundidade de indentação | `componente-aninhamento.md` |
| [[componente-responsabilidades\|Responsabilidades]] | Número de responsabilidades distintas | `componente-responsabilidades.md` |
| [[componente-acoplamento\|Acoplamento]] | Dependências externas diretas | `componente-acoplamento.md` |

## Tabelas de Referência Rápida

### CC_base (Complexidade Ciclomática)

| CC | ICP CC_base | Categoria |
|----|-------------|-----------|
| ≤ 5 | 1 | Simples |
| 6–10 | 2 | Moderado |
| 11–15 | 3 | Complexo |
| 16–20 | 4 | Muito Complexo |
| > 20 | 5 | Crítico |

**Pontos de decisão que incrementam CC:** `if`, `else if`, `for`, `while`, `do-while`, `case`, `&&`, `||`, `catch`, `?` (ternário)

### Aninhamento

| Profundidade máxima | Pontos |
|---------------------|--------|
| 1 nível | 0 |
| 2 níveis | 1 |
| 3 níveis | 2 |
| 4+ níveis | 3 |

### Responsabilidades

| Responsabilidades distintas | Pontos |
|-----------------------------|--------|
| 1 | 0 |
| 2–3 | 1 |
| 4–5 | 2 |
| 6+ | 3 |

### Acoplamento

| Dependências externas | Pontos |
|-----------------------|--------|
| 0–2 | 0 |
| 3–5 | 1 |
| 6+ | 2 |

## Limites de ICP e Ações

| ICP | Status | Ação recomendada |
|-----|--------|-----------------|
| ≤ 3 | 🟢 Excelente | Manter — carga cognitiva mínima |
| 4–6 | 🟡 Aceitável | Considerar refatoração na próxima iteração |
| 7–10 | 🟠 Preocupante | Refatorar antes de adicionar nova lógica |
| > 10 | 🔴 Crítico | Refatoração obrigatória — alto risco de bug |

## Exemplos de Cálculo

### Exemplo 1 — Função Simples (ICP = 1)

```javascript
function sum(a, b) {
  return a + b;
}
```

| Componente | Cálculo | Pontos |
|---|---|---|
| CC_base | CC = 1 (sem decisões) → ICP Base = 1 | 1 |
| Aninhamento | 0 níveis | 0 |
| Responsabilidades | 1 (transformação) | 0 |
| Acoplamento | 0 dependências | 0 |
| **ICP Total** | | **1** 🟢 |

### Exemplo 2 — Função Moderada (ICP = 4)

```javascript
function processPayment(order) {
  if (!order.isPaid) {
    const result = paymentGateway.charge(order.total);
    if (result.success) {
      order.markAsPaid();
      emailService.sendReceipt(order.email);
      return true;
    }
  }
  return false;
}
```

| Componente | Cálculo | Pontos |
|---|---|---|
| CC_base | CC = 3 (2 ifs + 1) → ICP Base = 1 | 1 |
| Aninhamento | 2 níveis (`if` dentro de `if`) | 1 |
| Responsabilidades | 3 (validação, pagamento, notificação) | 1 |
| Acoplamento | 3 (`paymentGateway`, `order`, `emailService`) | 1 |
| **ICP Total** | | **4** 🟡 |

### Exemplo 3 — Função Complexa (ICP = 8)

```javascript
function syncUserData(userId) {
  const user = database.users.findById(userId);
  if (user) {
    if (user.needsSync) {
      const remoteData = apiClient.fetchUserData(user.externalId);
      if (remoteData) {
        for (let field of remoteData.fields) {
          if (field.changed) {
            user[field.name] = field.value;
            auditLog.record('field_updated', { userId, field: field.name });
          }
        }
        user.lastSync = new Date();
        database.users.update(user);
        return true;
      }
    }
  }
  return false;
}
```

| Componente | Cálculo | Pontos |
|---|---|---|
| CC_base | CC = 6 (5 ifs/for + 1) → ICP Base = 2 | 2 |
| Aninhamento | 4 níveis (if > if > for > if) | 3 |
| Responsabilidades | 5 (consulta, validação, busca remota, transformação, persistência) | 2 |
| Acoplamento | 4 (`database`, `apiClient`, `auditLog`, `Date`) | 1 |
| **ICP Total** | | **8** 🟠 |

## Estratégias de Redução de ICP

### Reduzir CC_base → Extrair Método

```javascript
// Antes: CC = 5, ICP = 6
function processOrder(order) {
  if (!order.items.length) return false;
  if (!order.customer) return false;
  if (!order.isPaid) return false;
  if (!order.address) return false;
  order.ship();
  return true;
}

// Depois: CC = 2, ICP = 2
function processOrder(order) {
  if (!isValidOrder(order)) return false;
  order.ship();
  return true;
}

function isValidOrder(order) {
  return order.items.length > 0
    && order.customer
    && order.isPaid
    && order.address;
}
```

### Reduzir Aninhamento → Guard Clauses

```javascript
// Antes: 3 níveis de aninhamento → +2 ICP
function getDiscount(user) {
  if (user) {
    if (user.isPremium) {
      if (user.purchases > 10) {
        return 0.2;
      }
    }
  }
  return 0;
}

// Depois: 1 nível → +0 ICP
function getDiscount(user) {
  if (!user) return 0;
  if (!user.isPremium) return 0;
  if (user.purchases <= 10) return 0;
  return 0.2;
}
```

### Reduzir Responsabilidades → SRP

```javascript
// Antes: 4 responsabilidades → +2 ICP
function registerUser(email, password) {
  validateEmail(email);
  const hash = hashPassword(password);
  const user = database.insert({ email, password: hash });
  sendWelcomeEmail(email);
  return user;
}

// Depois: 1 responsabilidade (orquestração) → +0 ICP
function registerUser(email, password) {
  const user = userService.create(email, password);
  notificationService.sendWelcome(user);
  return user;
}
```

## Detecção Automática

Biome: [`noExcessiveCognitiveComplexity`](https://biomejs.dev/linter/rules/no-excessive-cognitive-complexity/) captura CC_base e Aninhamento automaticamente. Responsabilidades e Acoplamento requerem análise manual ou revisão de código.

## Relacionados

- [[componente-cc-base]] — detalhe do componente CC_base
- [[componente-aninhamento]] — detalhe do componente Aninhamento
- [[componente-responsabilidades]] — detalhe do componente Responsabilidades
- [[componente-acoplamento]] — detalhe do componente Acoplamento
- [[metodologia-cdd]] — contexto e aplicação do ICP na metodologia
- [[aplicacao-code-review]] — como usar o ICP em code reviews
