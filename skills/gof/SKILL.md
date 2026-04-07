---
name: gof
description: Complete reference of 23 GoF Design Patterns (Gang of Four) organized into Creational, Structural, and Behavioral. Use when needing to select or implement GoF patterns, upon receiving pattern recommendation from @architect, or when reviewing code with design problems that a pattern would solve.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "2.0.0"
  category: design-patterns
---

# GoF — Gang of Four Design Patterns

23 OO design patterns organized into 3 categories.

---

## When to Use

- @architect: Research/Spec phase to recommend patterns for features
- @developer: Code phase to implement the correct pattern
- @reviewer: to identify where a pattern should be applied (or was misapplied)

## The 23 Patterns

| Category | Pattern | Reference |
|-----------|---------|------------|
| Creational | Singleton | [singleton.md](references/singleton.md) |
| Creational | Factory Method | [factory-method.md](references/factory-method.md) |
| Creational | Abstract Factory | [abstract-factory.md](references/abstract-factory.md) |
| Creational | Builder | [builder.md](references/builder.md) |
| Creational | Prototype | [prototype.md](references/prototype.md) |
| Structural | Adapter | [adapter.md](references/adapter.md) |
| Structural | Bridge | [bridge.md](references/bridge.md) |
| Structural | Composite | [composite.md](references/composite.md) |
| Structural | Decorator | [decorator.md](references/decorator.md) |
| Structural | Facade | [facade.md](references/facade.md) |
| Structural | Flyweight | [flyweight.md](references/flyweight.md) |
| Structural | Proxy | [proxy.md](references/proxy.md) |
| Behavioral | Chain of Responsibility | [chain-of-responsibility.md](references/chain-of-responsibility.md) |
| Behavioral | Command | [command.md](references/command.md) |
| Behavioral | Interpreter | [interpreter.md](references/interpreter.md) |
| Behavioral | Iterator | [iterator.md](references/iterator.md) |
| Behavioral | Mediator | [mediator.md](references/mediator.md) |
| Behavioral | Memento | [memento.md](references/memento.md) |
| Behavioral | Observer | [observer.md](references/observer.md) |
| Behavioral | State | [state.md](references/state.md) |
| Behavioral | Strategy | [strategy.md](references/strategy.md) |
| Behavioral | Template Method | [template-method.md](references/template-method.md) |
| Behavioral | Visitor | [visitor.md](references/visitor.md) |

## Quick Selection by Problem

| Problem | Pattern |
|----------|---------|
| Create object without specifying concrete class | Factory Method |
| Switch algorithm at runtime | Strategy |
| Notify dependents when state changes | Observer |
| Single interface for complex subsystem | Facade |
| Add responsibilities without inheritance | Decorator |
| Single global instance | Singleton |
| Control access to another object | Proxy |
| Build complex object step by step | Builder |
| Chain of handlers for a request | Chain of Responsibility |
| Processing pipeline | Chain of Responsibility |
| State machine | State |
| Tree structure (UI components) | Composite |

## Examples

```typescript
// ❌ Bad — conditional logic that grows with each new type
function createNotification(type: string) {
  if (type === 'email') return new EmailNotification()
  if (type === 'sms') return new SmsNotification()
  if (type === 'push') return new PushNotification()
  // each new type = modify this method (violates OCP)
}

// ✅ Good — Factory Method: extensible without modifying existing code
abstract class NotificationFactory {
  abstract create(): Notification
}
class EmailFactory extends NotificationFactory {
  create() { return new EmailNotification() }
}
class SmsFactory extends NotificationFactory {
  create() { return new SmsNotification() }
}
// adding Push = new class, without changing existing ones
```

```typescript
// ❌ Bad — validation logic scattered and repeated
function processOrder(order: Order) {
  if (order.status === 'pending') {
    order.status = 'processing'
  } else if (order.status === 'processing') {
    order.status = 'shipped'
  } else if (order.status === 'shipped') {
    order.status = 'delivered'
  }
  // adding new status = modify entire conditional structure
}

// ✅ Good — State Pattern: each state encapsulates behavior
interface OrderState {
  next(order: Order): void
}
class PendingState implements OrderState {
  next(order: Order) { order.setState(new ProcessingState()) }
}
class ProcessingState implements OrderState {
  next(order: Order) { order.setState(new ShippedState()) }
}
// adding new state = new class, without modifying existing ones
```

## Prohibitions

- Don't use patterns for simple problems (overengineering — rule 064)
- Don't implement Singleton to inject dependencies (use DIP — rule 014)
- Never apply without clearly identifying the problem it solves

## Rationale

- rule 010 (SRP): each pattern has clear responsibility
- rule 011 (OCP): Factory Method and Strategy allow extension without modification
- rule 014 (DIP): Abstract Factory and Bridge depend on abstractions
- rule 064 (Overengineering): apply only when the problem justifies it

**Related skills:**
- [`poeaa`](../poeaa/SKILL.md) — complements: PoEAA applies GoF in enterprise architecture
- [`solid`](../solid/SKILL.md) — depends: many GoF patterns implement SOLID principles
