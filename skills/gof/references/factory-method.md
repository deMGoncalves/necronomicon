# Factory Method

**Category:** Creational
**Intent:** Define an interface for creating objects, but let subclasses decide which class to instantiate.

---

## When to Use

- When the exact type of object to be created depends on context
- When subclasses should be able to specialize the creation process
- To isolate object creation from the logic that uses them
- When integrating with multiple providers or adapters

## When NOT to Use

- When there's only one concrete type — a simple `new` is sufficient
- When `switch/if` to decide which class to create remains in high-level class (violates OCP — rule 011)
- For simple objects without creation variations (overengineering — rule 064)

## Minimal Structure (TypeScript)

```typescript
interface Notifier {
  send(message: string): Promise<void>
}

abstract class NotificationService {
  // Factory Method — subclasses implement
  protected abstract createNotifier(): Notifier

  async notify(message: string): Promise<void> {
    const notifier = this.createNotifier()
    await notifier.send(message)
  }
}

class EmailNotificationService extends NotificationService {
  protected createNotifier(): Notifier {
    return new EmailNotifier(process.env.SMTP_HOST)
  }
}
```

## Real Usage Example

```typescript
new EmailNotificationService().notify('Order confirmed')
```

## Related to

- [abstract-factory.md](abstract-factory.md): complements — Abstract Factory uses Factory Methods internally to create families
- [template-method.md](template-method.md): complements — both use inheritance to delegate behavior to subclasses
- [singleton.md](singleton.md): complements — Factory Method can control and return Singleton instance
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new types without modifying existing code
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — depends on abstraction, not on concrete class

---

**GoF Category:** Creational
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
