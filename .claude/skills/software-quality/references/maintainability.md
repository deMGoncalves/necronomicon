# Maintainability — Manutenibilidade

**Dimensão:** Revisão
**Severidade Default:** 🟠 Importante
**Pergunta Chave:** É fácil corrigir?

## O que é

O esforço necessário para localizar e corrigir um defeito no software. Alta manutenibilidade significa que bugs podem ser encontrados rapidamente, as causas são óbvias, e correções podem ser feitas sem efeitos colaterais.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| God class (> 500 linhas) | 🔴 Blocker |
| Método com CC > 10 | 🟠 Important |
| Código duplicado significativo | 🟠 Important |
| Logs insuficientes | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não manutenível - classe faz tudo
class OrderManager {
  createOrder() { /* ... */ }
  validateOrder() { /* ... */ }
  calculateTax() { /* ... */ }
  sendEmail() { /* ... */ }
  // ... 500 linhas de código
}

// ✅ Manutenível - responsabilidades separadas
class OrderService {
  constructor(validator, calculator, notifier) {
    this.validator = validator;
    this.calculator = calculator;
    this.notifier = notifier;
  }

  async createOrder(data) {
    const order = this.validator.validate(data);
    order.total = this.calculator.calculate(order);
    await this.notifier.notify(order);
    return order;
  }
}
```

## Codetags Sugeridos

```javascript
// REFACTOR: Esta classe viola SRP - separar em serviços menores
// REFACTOR: Método muito complexo - extrair submétodos
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| God class (> 500 linhas) | 🔴 Blocker |
| Método com CC > 10 | 🟠 Important |
| Código duplicado significativo | 🟠 Important |
| Logs insuficientes | 🟡 Suggestion |

## Rules Relacionadas

- 010 - Princípio da Responsabilidade Única
- 007 - Limite Máximo de Linhas por Classe
- 025 - Proibição do Anti-Pattern The Blob
