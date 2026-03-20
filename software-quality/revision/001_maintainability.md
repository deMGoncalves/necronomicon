# Maintainability (Manutenibilidade)

**Dimensão**: Revisão
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**É fácil corrigir?**

## Definição

O esforço necessário para localizar e corrigir um defeito no software. Alta manutenibilidade significa que bugs podem ser encontrados rapidamente, as causas são óbvias, e correções podem ser feitas sem efeitos colaterais.

## Critérios de Verificação

- [ ] Código segue princípio da responsabilidade única (SRP)
- [ ] Funções/métodos com baixa complexidade ciclomática (CC ≤ 5)
- [ ] Nomes claros e autoexplicativos
- [ ] Estrutura de código previsível e consistente
- [ ] Logs adequados para diagnóstico
- [ ] Documentação de decisões arquiteturais

## Indicadores de Problema

### Exemplo 1: God Class (Blob)

```javascript
// ❌ Não manutenível - classe faz tudo
class OrderManager {
  createOrder() { /* ... */ }
  validateOrder() { /* ... */ }
  calculateTax() { /* ... */ }
  applyDiscount() { /* ... */ }
  sendEmail() { /* ... */ }
  generatePDF() { /* ... */ }
  updateInventory() { /* ... */ }
  processPayment() { /* ... */ }
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

### Exemplo 2: Função Longa e Complexa

```javascript
// ❌ Não manutenível - difícil entender e modificar
function processOrder(order) {
  // 100 linhas de validação
  // 50 linhas de cálculo
  // 30 linhas de persistência
  // 20 linhas de notificação
  // Total: 200+ linhas, CC > 20
}

// ✅ Manutenível - funções pequenas e focadas
function processOrder(order) {
  validateOrder(order);
  calculateTotals(order);
  persistOrder(order);
  notifyStakeholders(order);
}
```

### Exemplo 3: Acoplamento Alto

```javascript
// ❌ Não manutenível - depende de implementação concreta
class ReportGenerator {
  generate() {
    const db = new MySQLConnection('localhost', 'root', 'pass');
    const data = db.query('SELECT * FROM sales');
    // Impossível testar sem banco real
  }
}

// ✅ Manutenível - depende de abstração
class ReportGenerator {
  constructor(dataSource) {
    this.dataSource = dataSource;
  }

  generate() {
    const data = this.dataSource.getSalesData();
    // Fácil de testar com mock
  }
}
```

### Exemplo 4: Logs Ausentes ou Inadequados

```javascript
// ❌ Não manutenível - sem contexto para debug
async function syncData() {
  try {
    await externalApi.fetch();
  } catch (error) {
    console.log('erro'); // Qual erro? Onde? Por quê?
  }
}

// ✅ Manutenível - logs estruturados e contextuais
async function syncData() {
  logger.info('Starting data sync', { source: 'external-api' });
  try {
    const result = await externalApi.fetch();
    logger.info('Sync completed', { recordCount: result.length });
  } catch (error) {
    logger.error('Sync failed', {
      error: error.message,
      code: error.code,
      stack: error.stack
    });
    throw error;
  }
}
```

## Sinais de Alerta em Code Review

1. **Classes/arquivos** com mais de 200 linhas
2. **Métodos** com mais de 20 linhas ou CC > 5
3. **Múltiplas responsabilidades** em uma classe
4. **Dependências concretas** injetadas diretamente
5. **Console.log** em vez de logger estruturado
6. **Código duplicado** em múltiplos lugares

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| God class | Bug pode estar em qualquer lugar |
| Sem logs | Horas para diagnosticar problemas |
| Alto acoplamento | Mudança causa efeitos cascata |
| Código duplicado | Bug corrigido em um lugar, não no outro |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| God class (> 500 linhas) | 🔴 Blocker |
| Método com CC > 10 | 🟠 Important |
| Código duplicado significativo | 🟠 Important |
| Logs insuficientes | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// REFACTOR: Esta classe viola SRP - separar em serviços menores
// REFACTOR: Método muito complexo - extrair submétodos

// TODO: Adicionar logs estruturados para diagnóstico
// TODO: Extrair dependência concreta para interface
```

## Exemplo de Comentário em Review

```
Esta clase tiene demasiadas responsabilidades:
- Validación
- Cálculo
- Persistencia
- Notificación

Considera separarla siguiendo SRP:

class OrderValidator { validate() }
class OrderCalculator { calculate() }
class OrderRepository { save() }
class OrderNotifier { notify() }

🟠 Importante para manutenibilidad
```

## Rules Relacionadas

- [solid/001 - Single Responsibility](../../solid/001_principio-responsabilidade-unica.md)
- [object-calisthenics/007 - Max Lines](../../object-calisthenics/007_limite-maximo-linhas-classe.md)
- [clean-code/005 - No Blob](../../clean-code/proibicao-anti-padrao-blob.md)

## Patterns Relacionados

- [gof/creational/001 - Abstract Factory](../../gof/creational/001_abstract-factory.md): para desacoplamento
- [gof/structural/004 - Decorator](../../gof/structural/004_decorator.md): para extensão sem modificação
- [poeaa/domain-logic/002 - Domain Model](../../poeaa/domain-logic/002_domain-model.md): para organização de lógica

---

**Criada em**: 2026-03-18
**Versão**: 1.0
