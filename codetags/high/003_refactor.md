# REFACTOR

**Severidade**: 🟠 High
**Categoria**: Ação Requerida
**Resolver**: Sprint atual ou próxima

---

## Definição

Marca código que **viola princípios de design** ou boas práticas e precisa ser reestruturado. O código funciona corretamente mas sua estrutura dificulta manutenção, teste ou evolução.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Violação de SOLID | Classe com múltiplas responsabilidades |
| God Class/Function | Arquivo com 500+ linhas |
| Alto acoplamento | Dependências circulares |
| Código duplicado | Mesma lógica em vários lugares |
| Complexidade excessiva | CC > 10 |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Código com bug | FIXME |
| Solução temporária | HACK |
| Otimização de performance | OPTIMIZE |
| Código a ser removido | DEPRECATED |

## Formato

```javascript
// REFACTOR: princípio violado - ação sugerida
// REFACTOR: [SRP] descrição - extrair para classe X
// REFACTOR: CC=15 - dividir em funções menores
```

## Exemplos

### Exemplo 1: Violação SRP (Single Responsibility)

```javascript
// REFACTOR: [SRP] classe faz validação + persistência + notificação
// Extrair: OrderValidator, OrderRepository, OrderNotifier
class OrderService {
  createOrder(data) {
    // Validação (deveria estar em OrderValidator)
    if (!data.items) throw new Error('Items required');
    if (!data.customer) throw new Error('Customer required');

    // Persistência (deveria estar em OrderRepository)
    const order = db.orders.create(data);

    // Notificação (deveria estar em OrderNotifier)
    emailService.send(order.customer.email, 'Order created');

    return order;
  }
}
```

### Exemplo 2: God Function

```javascript
// REFACTOR: função com 150 linhas e CC=20
// Extrair: validateInput(), calculateTotals(), applyDiscounts(), formatOutput()
function processOrder(order) {
  // 150 linhas de código misturando várias responsabilidades
  // ...
}
```

### Exemplo 3: Código Duplicado

```javascript
// REFACTOR: [DRY] lógica de formatação duplicada em 5 arquivos
// Extrair para utils/formatters.js
function formatUserName(user) {
  return `${user.firstName} ${user.lastName}`.trim().toUpperCase();
}

// Mesmo código em outro arquivo...
function formatCustomerName(customer) {
  return `${customer.firstName} ${customer.lastName}`.trim().toUpperCase();
}
```

### Exemplo 4: Alto Acoplamento

```javascript
// REFACTOR: [DIP] depende de implementação concreta
// Injetar interface IEmailService em vez de SendGridService
class NotificationService {
  constructor() {
    this.emailService = new SendGridService(); // ❌ Acoplamento forte
  }
}

// ✅ Após refatoração
class NotificationService {
  constructor(emailService) {
    this.emailService = emailService; // Interface injetada
  }
}
```

### Exemplo 5: Switch/If Crescente

```javascript
// REFACTOR: [OCP] switch cresce a cada novo tipo de pagamento
// Usar Strategy pattern com PaymentProcessorRegistry
function processPayment(payment) {
  switch (payment.type) {
    case 'credit': return processCreditCard(payment);
    case 'debit': return processDebitCard(payment);
    case 'pix': return processPix(payment);
    case 'boleto': return processBoleto(payment);
    // Cada novo tipo adiciona mais um case...
  }
}
```

### Exemplo 6: Complexidade Ciclomática Alta

```javascript
// REFACTOR: CC=12 - extrair condições para funções predicado
function calculateDiscount(order) {
  let discount = 0;

  if (order.customer.isPremium) {
    if (order.total > 1000) {
      if (order.items.length > 5) {
        discount = 0.2;
      } else {
        discount = 0.15;
      }
    } else {
      discount = 0.1;
    }
  } else if (order.customer.isRecurring) {
    // ... mais aninhamento
  }

  return discount;
}
```

## Princípios Comumente Violados

| Princípio | Sintoma | Ação |
|-----------|---------|------|
| SRP | Classe faz muitas coisas | Extrair classes |
| OCP | Switch/if crescente | Usar polimorfismo |
| DIP | new Concrete() | Injetar dependência |
| DRY | Código duplicado | Extrair função/classe |
| KISS | CC > 5 | Dividir em funções |

## Ação Esperada

1. **Identificar** o princípio violado
2. **Documentar** a refatoração necessária
3. **Estimar** esforço e impacto
4. **Priorizar** no backlog técnico
5. **Executar** com testes adequados
6. **Remover** o comentário após refatoração

## Resolução

| Severidade da Violação | Quando Resolver |
|------------------------|-----------------|
| God class crítica | Sprint atual |
| Duplicação significativa | Próxima sprint |
| Acoplamento moderado | Backlog técnico |
| Melhoria incremental | Boy Scout Rule |

## Busca no Código

```bash
# Encontrar todos os REFACTORs
grep -rn "REFACTOR:" src/

# REFACTORs por princípio
grep -rn "REFACTOR:.*\[SRP\]\|REFACTOR:.*\[OCP\]" src/

# Arquivos com mais REFACTORs
grep -rc "REFACTOR:" src/ | grep -v ":0" | sort -t: -k2 -rn
```

## Anti-Patterns

```javascript
// ❌ REFACTOR sem especificar o problema
// REFACTOR:
function needsWork() { }

// ❌ REFACTOR vago
// REFACTOR: melhorar isso
function needsWork() { }

// ❌ REFACTOR para código funcional simples
// REFACTOR: poderia ser melhor
function actuallyFine() { }

// ❌ REFACTOR eterno
// REFACTOR: (2019) um dia vamos arrumar
function neverFixed() { }
```

## Quality Factor Relacionado

- [Maintainability](../../software-quality/revision/001_maintainability.md): REFACTOR melhora manutenibilidade
- [Flexibility](../../software-quality/revision/002_flexibility.md): código bem estruturado é mais flexível
- [Testability](../../software-quality/revision/003_testability.md): código desacoplado é mais testável

## Rules Relacionadas

- [solid/001 - SRP](../../solid/001_single-responsibility-principle.md)
- [solid/002 - OCP](../../solid/002_open-closed-principle.md)
- [clean-code/001 - DRY](../../clean-code/001_prohibition-logic-duplication.md)
- [clean-code/005 - No Blob](../../clean-code/005_prohibition-blob-anti-pattern.md)

---

**Criada em**: 2026-03-19
**Versão**: 1.0
