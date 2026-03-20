# Cálculo de ICP (Intrinsic Complexity Points)

## Fórmula Geral

```
ICP = CC_base + Nesting + Responsibilities + Coupling
```

## Componente 1: Complexidade Ciclomática Base

A CC mede o número de caminhos independentes pelo código.

### Cálculo de CC

CC = número de pontos de decisão + 1

**Pontos de decisão:**
- `if`, `else if`
- `for`, `while`, `do-while`
- `case` em `switch`
- `&&`, `||` em condições
- `catch` em try-catch
- `?` no operador ternário

### Conversão para ICP Base

| CC | ICP Base | Categoria |
|----|----------|-----------|
| ≤ 5 | 1 | Simples |
| 6-10 | 2 | Moderado |
| 11-15 | 3 | Complexo |
| 16-20 | 4 | Muito Complexo |
| > 20 | 5 | Crítico |

**Exemplo:**

```javascript
// CC = 4 (3 ifs + 1) → ICP Base = 1
function validateEmail(email) {
  if (!email) return false;
  if (!email.includes('@')) return false;
  if (email.length < 5) return false;
  return true;
}
```

## Componente 2: Profundidade de Aninhamento

Mede quantos níveis de indentação o código possui.

### Pontuação

| Níveis | Pontos | Exemplo |
|--------|--------|---------|
| 1 | 0 | Código linear com guard clauses |
| 2 | 1 | Um nível de `if` ou `for` |
| 3 | 2 | `if` dentro de `for` |
| 4+ | 3 | Aninhamento profundo |

**Exemplo:**

```javascript
// Aninhamento = 3 níveis → +2 pontos
function processOrders(orders) {
  for (let order of orders) {           // Nível 1
    if (order.isPaid) {                  // Nível 2
      for (let item of order.items) {    // Nível 3
        item.ship();
      }
    }
  }
}
```

## Componente 3: Número de Responsabilidades

Mede violações do SRP (Single Responsibility Principle).

### Identificação de Responsabilidades

Uma função tem múltiplas responsabilidades se fizer 2 ou mais das seguintes:

1. Validação de dados
2. Transformação de dados
3. Persistência (salvar, atualizar, excluir)
4. Consulta (buscar, ler)
5. Lógica de negócio
6. Formatação/apresentação
7. Logging/auditoria
8. Tratamento de erros

### Pontuação

| Responsabilidades | Pontos |
|-------------------|--------|
| 1 | 0 |
| 2-3 | 1 |
| 4-5 | 2 |
| 6+ | 3 |

**Exemplo:**

```javascript
// 3 responsabilidades → +1 ponto
// 1. Validação, 2. Transformação, 3. Persistência
function createUser(data) {
  // 1. Validação
  if (!data.email) throw new Error('Invalid email');

  // 2. Transformação
  const user = {
    email: data.email.toLowerCase(),
    name: data.name.trim()
  };

  // 3. Persistência
  database.users.insert(user);
  return user;
}
```

## Componente 4: Acoplamento (Opcional)

Mede dependências externas diretas.

### Pontuação

| Dependências | Pontos |
|--------------|--------|
| 0-2 | 0 |
| 3-5 | 1 |
| 6+ | 2 |

**Exemplo:**

```javascript
// 4 dependências → +1 ponto
import { validateEmail } from './validators';
import { hashPassword } from './crypto';
import { sendEmail } from './mailer';
import { database } from './db';

function registerUser(email, password) {
  validateEmail(email);
  const hash = hashPassword(password);
  database.insert({ email, password: hash });
  sendEmail(email, 'Welcome');
}
```

## Cálculo Completo: Exemplos

### Exemplo 1: Função Simples

```javascript
function sum(a, b) {
  return a + b;
}
```

- CC: 1 → ICP Base = 1
- Aninhamento: 0 níveis → +0
- Responsabilidades: 1 (transformação) → +0
- Acoplamento: 0 → +0

**ICP Total: 1** 🟢 (Excelente)

---

### Exemplo 2: Função Moderada

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

- CC: 3 (2 ifs + 1) → ICP Base = 1
- Aninhamento: 2 níveis → +1
- Responsabilidades: 3 (validação, pagamento, notificação) → +1
- Acoplamento: 3 (paymentGateway, order, emailService) → +1

**ICP Total: 4** 🟡 (Aceitável, considere refatoração)

---

### Exemplo 3: Função Complexa

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

- CC: 6 (5 ifs/for + 1) → ICP Base = 2
- Aninhamento: 4 níveis → +3
- Responsabilidades: 5 (consulta, validação, busca, transformação, persistência) → +2
- Acoplamento: 4 (database, apiClient, auditLog, Date) → +1

**ICP Total: 8** 🟠 (Preocupante, refatoração recomendada)

---

## Limites e Ações de ICP

| ICP | Status | Ação |
|-----|--------|------|
| ≤ 3 | 🟢 Excelente | Manter |
| 4-6 | 🟡 Aceitável | Considerar refatoração |
| 7-10 | 🟠 Preocupante | Refatoração recomendada |
| > 10 | 🔴 Crítico | Refatoração obrigatória |

## Estratégias de Redução de ICP

### 1. Reduzir CC → Extrair Método

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

### 2. Reduzir Aninhamento → Retorno Antecipado

```javascript
// Antes: Aninhamento = 3
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

// Depois: Aninhamento = 1
function getDiscount(user) {
  if (!user) return 0;
  if (!user.isPremium) return 0;
  if (user.purchases <= 10) return 0;
  return 0.2;
}
```

### 3. Reduzir Responsabilidades → SRP

```javascript
// Antes: 4 responsabilidades
function registerUser(email, password) {
  validateEmail(email);
  const hash = hashPassword(password);
  const user = database.insert({ email, password: hash });
  sendWelcomeEmail(email);
  return user;
}

// Depois: 1 responsabilidade (orquestração)
function registerUser(email, password) {
  const user = userService.create(email, password);
  notificationService.sendWelcome(user);
  return user;
}
```

## Ferramentas

- **Manual**: Contagem visual dos componentes
- **Automático**: ESLint com plugins `complexity`, `max-depth`, `max-lines-per-function`
- **IDE**: Plugins que calculam CC e exibem métricas

## Versão

Cálculo de ICP v1.0 - Março 2026
