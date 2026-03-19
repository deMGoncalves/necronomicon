# Testability (Testabilidade)

**Dimensão**: Revisão
**Severidade Default**: 🔴 Critical

---

## Pergunta Chave

**É fácil testar?**

## Definição

O esforço necessário para testar o software e garantir que ele funciona corretamente. Alta testabilidade significa que componentes podem ser testados isoladamente, com entradas e saídas claras, sem depender de infraestrutura externa.

## Critérios de Verificação

- [ ] Dependências injetáveis (fácil de criar mocks)
- [ ] Funções puras quando possível
- [ ] Sem estado global ou singletons ocultos
- [ ] Efeitos colaterais isolados e explícitos
- [ ] Cobertura de testes adequada (≥ 85% em domínio)
- [ ] Testes seguem padrão AAA (Arrange, Act, Assert)

## Indicadores de Problema

### Exemplo 1: Dependência Não Injetável

```javascript
// ❌ Não testável - cria dependência internamente
class UserService {
  async getUser(id) {
    const db = new DatabaseConnection(); // Impossível mockar
    return db.query(`SELECT * FROM users WHERE id = ${id}`);
  }
}

// ✅ Testável - dependência injetada
class UserService {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async getUser(id) {
    return this.userRepository.findById(id);
  }
}

// No teste:
const mockRepo = { findById: vi.fn().mockResolvedValue(mockUser) };
const service = new UserService(mockRepo);
```

### Exemplo 2: Função Impura com Efeitos Colaterais

```javascript
// ❌ Não testável - efeitos colaterais escondidos
function processOrder(order) {
  const discount = calculateDiscount(order);
  order.total = order.subtotal - discount; // Muta o objeto
  sendEmail(order.customerEmail);          // Efeito colateral
  updateInventory(order.items);            // Efeito colateral
  return order;
}

// ✅ Testável - função pura + efeitos separados
function calculateOrderTotal(order) {
  const discount = calculateDiscount(order);
  return {
    ...order,
    total: order.subtotal - discount
  };
}

// Efeitos colaterais explícitos e separados
async function processOrder(order, { emailService, inventoryService }) {
  const processed = calculateOrderTotal(order);
  await emailService.send(processed.customerEmail);
  await inventoryService.update(processed.items);
  return processed;
}
```

### Exemplo 3: Estado Global/Singleton

```javascript
// ❌ Não testável - singleton escondido
class ConfigManager {
  static instance = null;

  static getInstance() {
    if (!this.instance) {
      this.instance = new ConfigManager();
    }
    return this.instance;
  }
}

function getFeatureFlag(name) {
  return ConfigManager.getInstance().get(name); // Estado global
}

// ✅ Testável - dependência explícita
function getFeatureFlag(name, config) {
  return config.get(name);
}

// No teste:
const mockConfig = { get: vi.fn().mockReturnValue(true) };
expect(getFeatureFlag('feature-x', mockConfig)).toBe(true);
```

### Exemplo 4: Acoplamento com Time/Date

```javascript
// ❌ Não testável - depende de tempo real
function isExpired(expirationDate) {
  return new Date() > expirationDate; // Data atual não controlável
}

// ✅ Testável - tempo injetável
function isExpired(expirationDate, currentDate = new Date()) {
  return currentDate > expirationDate;
}

// No teste:
const expiration = new Date('2024-01-01');
const current = new Date('2024-06-01');
expect(isExpired(expiration, current)).toBe(true);
```

### Exemplo 5: Testes com Lógica

```javascript
// ❌ Má prática - lógica no teste
test('calculates discount', () => {
  const orders = [order1, order2, order3];
  for (const order of orders) {
    const result = calculateDiscount(order);
    if (order.total > 100) {
      expect(result).toBe(order.total * 0.1);
    } else {
      expect(result).toBe(0);
    }
  }
});

// ✅ Boa prática - um cenário por teste
test('applies 10% discount for orders over 100', () => {
  const order = { total: 150 };
  expect(calculateDiscount(order)).toBe(15);
});

test('no discount for orders under 100', () => {
  const order = { total: 50 };
  expect(calculateDiscount(order)).toBe(0);
});
```

## Sinais de Alerta em Code Review

1. **new Dependency()** dentro de métodos de negócio
2. **Singletons** ou estado global acessado diretamente
3. **Date.now()** ou **Math.random()** sem injeção
4. **Funções que mutam** objetos recebidos
5. **Múltiplas responsabilidades** misturadas
6. **Testes com if/for/while** no corpo

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Dependência não injetável | Teste requer infra real |
| Estado global | Testes interferem entre si |
| Efeitos colaterais | Testes lentos e frágeis |
| Lógica no teste | Teste pode ter bugs |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Código de negócio impossível de testar | 🔴 Blocker |
| Singleton usado em lógica crítica | 🔴 Blocker |
| Dependência concreta em Service | 🟠 Important |
| Date.now() sem injeção | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// TEST: Impossível testar - dependência concreta interna
// TEST: Necessário mockar time para testar

// TODO: Extrair dependência para injeção
// TODO: Separar função pura de efeitos colaterais
```

## Exemplo de Comentário em Review

```
Esta función es difícil de testear porque crea la dependencia internamente:

async function sendReport() {
  const emailClient = new SendGridClient(); // ❌ No mockeable
  await emailClient.send(report);
}

Mejor inyectarla:

async function sendReport(emailClient) {
  await emailClient.send(report);
}

Así en tests puedes usar un mock:
const mock = { send: vi.fn() };
await sendReport(mock);

🔴 Crítico - afecta testabilidad
```

## Rules Relacionadas

- [solid/005 - Dependency Inversion](../../solid/005_principio-inversao-dependencia.md)
- [clean-code/012 - Test Coverage](../../clean-code/012_cobertura-teste-minima-qualidade.md)
- [clean-code/016 - Side Effects](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md)

## Patterns Relacionados

- [gof/creational/001 - Abstract Factory](../../gof/creational/001_abstract-factory.md): para criar dependências injetáveis
- [gof/behavioral/009 - Strategy](../../gof/behavioral/009_strategy.md): para comportamentos intercambiáveis
- [poeaa/base/009 - Service Stub](../../poeaa/base/009_service-stub.md): para substituir serviços em testes

---

**Criada em**: 2026-03-18
**Versão**: 1.0
