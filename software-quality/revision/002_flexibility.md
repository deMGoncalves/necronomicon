# Flexibility (Flexibilidade)

**Dimensão**: Revisão
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**É fácil mudar?**

## Definição

O esforço necessário para modificar o software para atender a novos requisitos ou mudanças de negócio. Alta flexibilidade significa que novas funcionalidades podem ser adicionadas sem alterar código existente (Open/Closed Principle).

## Critérios de Verificação

- [ ] Código segue princípio aberto/fechado (OCP)
- [ ] Baixo acoplamento entre módulos
- [ ] Abstrações estáveis, implementações variáveis
- [ ] Inversão de dependência aplicada
- [ ] Composição preferida sobre herança
- [ ] Extensibilidade via interfaces/contratos

## Indicadores de Problema

### Exemplo 1: Violação do Open/Closed

```javascript
// ❌ Não flexível - precisa modificar para cada novo tipo
function calculateShipping(order) {
  switch (order.type) {
    case 'standard': return order.weight * 5;
    case 'express': return order.weight * 10;
    case 'overnight': return order.weight * 20;
    // Cada novo tipo requer modificar esta função
  }
}

// ✅ Flexível - extensível sem modificação
class ShippingCalculator {
  constructor(strategies) {
    this.strategies = strategies;
  }

  calculate(order) {
    const strategy = this.strategies.get(order.type);
    return strategy.calculate(order);
  }
}

// Adicionar novo tipo não requer modificar o calculador
shippingStrategies.set('same-day', new SameDayShipping());
```

### Exemplo 2: Dependência Concreta

```javascript
// ❌ Não flexível - acoplado a implementação específica
class OrderService {
  constructor() {
    this.emailService = new SendGridEmailService();
    this.paymentGateway = new StripePaymentGateway();
  }
}

// ✅ Flexível - depende de abstrações
class OrderService {
  constructor(emailService, paymentGateway) {
    this.emailService = emailService;
    this.paymentGateway = paymentGateway;
  }
}

// Fácil trocar implementações
new OrderService(new MailchimpEmailService(), new PayPalGateway());
```

### Exemplo 3: Herança Rígida

```javascript
// ❌ Não flexível - hierarquia profunda e rígida
class Animal { }
class Mammal extends Animal { }
class Dog extends Mammal { }
class Labrador extends Dog { }
// Mudar comportamento requer modificar toda a hierarquia

// ✅ Flexível - composição sobre herança
class Animal {
  constructor(movementBehavior, soundBehavior) {
    this.movement = movementBehavior;
    this.sound = soundBehavior;
  }

  move() { this.movement.execute(); }
  makeSound() { this.sound.execute(); }
}

// Comportamentos podem ser combinados livremente
new Animal(new WalkBehavior(), new BarkBehavior());
```

### Exemplo 4: Módulos Fortemente Acoplados

```javascript
// ❌ Não flexível - módulos conhecem detalhes uns dos outros
// user-module.js
import { saveToPostgres } from './database/postgres';
import { sendViaMailchimp } from './email/mailchimp';

function createUser(data) {
  saveToPostgres('users', data);
  sendViaMailchimp('welcome', data.email);
}

// ✅ Flexível - módulos comunicam via interfaces
// user-module.js
function createUser(data, { repository, emailService }) {
  repository.save(data);
  emailService.send('welcome', data.email);
}

// Configuração via composição
createUser(data, {
  repository: new PostgresRepository(),
  emailService: new MailchimpService()
});
```

## Sinais de Alerta em Code Review

1. **Switch/if-else** crescendo com cada novo tipo
2. **new ConcreteClass()** dentro de classes de negócio
3. **Hierarquias de herança** com mais de 2 níveis
4. **Imports diretos** de implementações concretas
5. **Múltiplos arquivos** alterados para uma única feature
6. **Dependências circulares** entre módulos

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Violação OCP | Regressão a cada mudança |
| Alto acoplamento | Mudança em cascata |
| Herança rígida | Impossível customizar |
| Dependências circulares | Build/deploy frágil |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Dependência circular entre módulos | 🔴 Blocker |
| Switch com > 5 cases crescentes | 🟠 Important |
| new Concrete() em classe de negócio | 🟠 Important |
| Herança > 3 níveis | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// OCP: Este switch viola Open/Closed - considerar Strategy
// DIP: Dependência concreta - injetar via construtor

// TODO: Extrair interface para desacoplar
// TODO: Substituir herança por composição
```

## Exemplo de Comentário em Review

```
Este switch va a crecer cada vez que agregues un nuevo tipo de pago:

switch (paymentType) {
  case 'credit': ...
  case 'debit': ...
  // ❌ Cada nuevo tipo modifica este código
}

Mejor usar Strategy pattern:

const processor = paymentStrategies.get(paymentType);
processor.process(payment);

Así agregar un nuevo tipo no requiere modificar código existente.

🟠 Importante para flexibilidad (OCP)
```

## Rules Relacionadas

- [solid/002 - Open/Closed Principle](../../solid/002_principio-aberto-fechado.md)
- [solid/005 - Dependency Inversion](../../solid/005_principio-inversao-dependencia.md)
- [package-principles/004 - Acyclic Dependencies](../../package-principles/004_principio-dependencias-aciclicas.md)

## Patterns Relacionados

- [gof/behavioral/009 - Strategy](../../gof/behavioral/009_strategy.md): para comportamentos intercambiáveis
- [gof/structural/004 - Decorator](../../gof/structural/004_decorator.md): para extensão dinâmica
- [gof/creational/003 - Factory Method](../../gof/creational/003_factory-method.md): para criação flexível

---

**Criada em**: 2026-03-18
**Versão**: 1.0
