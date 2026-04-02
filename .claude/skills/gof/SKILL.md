---
name: gof
description: Referência completa dos 23 GoF Design Patterns (Gang of Four) organizados em Criacionais, Estruturais e Comportamentais. Use quando precisar selecionar ou implementar padrões GoF, ao receber recomendação de pattern do @architect, ou ao revisar código com problemas de design que um pattern resolveria.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "2.0.0"
  category: design-patterns
---

# GoF — Gang of Four Design Patterns

23 padrões de design OO organizados em 3 categorias.

---

## Quando Usar

- @architect: fase Research/Spec para recomendar patterns para features
- @developer: fase Code para implementar o pattern correto
- @reviewer: para identificar onde um pattern deveria ser aplicado (ou foi mal aplicado)

## Os 23 Patterns

| Categoria | Pattern | Referência |
|-----------|---------|------------|
| Criacional | Singleton | [singleton.md](references/singleton.md) |
| Criacional | Factory Method | [factory-method.md](references/factory-method.md) |
| Criacional | Abstract Factory | [abstract-factory.md](references/abstract-factory.md) |
| Criacional | Builder | [builder.md](references/builder.md) |
| Criacional | Prototype | [prototype.md](references/prototype.md) |
| Estrutural | Adapter | [adapter.md](references/adapter.md) |
| Estrutural | Bridge | [bridge.md](references/bridge.md) |
| Estrutural | Composite | [composite.md](references/composite.md) |
| Estrutural | Decorator | [decorator.md](references/decorator.md) |
| Estrutural | Facade | [facade.md](references/facade.md) |
| Estrutural | Flyweight | [flyweight.md](references/flyweight.md) |
| Estrutural | Proxy | [proxy.md](references/proxy.md) |
| Comportamental | Chain of Responsibility | [chain-of-responsibility.md](references/chain-of-responsibility.md) |
| Comportamental | Command | [command.md](references/command.md) |
| Comportamental | Interpreter | [interpreter.md](references/interpreter.md) |
| Comportamental | Iterator | [iterator.md](references/iterator.md) |
| Comportamental | Mediator | [mediator.md](references/mediator.md) |
| Comportamental | Memento | [memento.md](references/memento.md) |
| Comportamental | Observer | [observer.md](references/observer.md) |
| Comportamental | State | [state.md](references/state.md) |
| Comportamental | Strategy | [strategy.md](references/strategy.md) |
| Comportamental | Template Method | [template-method.md](references/template-method.md) |
| Comportamental | Visitor | [visitor.md](references/visitor.md) |

## Seleção Rápida por Problema

| Problema | Pattern |
|----------|---------|
| Criar objeto sem especificar classe concreta | Factory Method |
| Trocar algoritmo em runtime | Strategy |
| Notificar dependentes quando estado muda | Observer |
| Interface única para subsistema complexo | Facade |
| Adicionar responsabilidades sem herança | Decorator |
| Uma única instância global | Singleton |
| Controlar acesso a outro objeto | Proxy |
| Construir objeto complexo passo a passo | Builder |
| Cadeia de handlers para uma requisição | Chain of Responsibility |
| Pipeline de processamento | Chain of Responsibility |
| Máquina de estados | State |
| Estrutura em árvore (componentes UI) | Composite |

## Exemplos

```typescript
// ❌ Ruim — lógica condicional que cresce com cada novo tipo
function createNotification(type: string) {
  if (type === 'email') return new EmailNotification()
  if (type === 'sms') return new SmsNotification()
  if (type === 'push') return new PushNotification()
  // cada novo tipo = modificar este método (viola OCP)
}

// ✅ Bom — Factory Method: extensível sem modificar código existente
abstract class NotificationFactory {
  abstract create(): Notification
}
class EmailFactory extends NotificationFactory {
  create() { return new EmailNotification() }
}
class SmsFactory extends NotificationFactory {
  create() { return new SmsNotification() }
}
// adicionar Push = nova classe, sem alterar existentes
```

```typescript
// ❌ Ruim — lógica de validação espalhada e repetida
function processOrder(order: Order) {
  if (order.status === 'pending') {
    order.status = 'processing'
  } else if (order.status === 'processing') {
    order.status = 'shipped'
  } else if (order.status === 'shipped') {
    order.status = 'delivered'
  }
  // adicionar novo status = modificar toda estrutura condicional
}

// ✅ Bom — State Pattern: cada estado encapsula comportamento
interface OrderState {
  next(order: Order): void
}
class PendingState implements OrderState {
  next(order: Order) { order.setState(new ProcessingState()) }
}
class ProcessingState implements OrderState {
  next(order: Order) { order.setState(new ShippedState()) }
}
// adicionar novo estado = nova classe, sem modificar existentes
```

## Proibições

- Não use patterns para problemas simples (overengineering — rule 064)
- Não implemente Singleton para injetar dependências (use DIP — rule 014)
- Nunca aplique sem identificar claramente o problema que resolve

## Fundamentação

- rule 010 (SRP): cada pattern tem responsabilidade clara
- rule 011 (OCP): Factory Method e Strategy permitem extensão sem modificação
- rule 014 (DIP): Abstract Factory e Bridge dependem de abstrações
- rule 064 (Overengineering): aplicar apenas quando o problema justifica

**Skills relacionadas:**
- [`poeaa`](../poeaa/SKILL.md) — complementa: PoEAA aplica GoF em arquitetura enterprise
- [`solid`](../solid/SKILL.md) — depende: muitos GoF patterns implementam princípios SOLID
