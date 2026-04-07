# Mediator

**Category:** Behavioral
**Intent:** Define an object that encapsulates how a set of objects interact, promoting loose coupling by preventing objects from explicitly referencing each other.

---

## When to Use

- Reduce coupling between components that communicate intensively
- Orchestrate complex interactions between multiple objects
- Implement chat systems, event rooms
- Coordinate UI components with shared state

## When NOT to Use

- When Mediator accumulates business logic — becomes God Object (rule 025 — The Blob)
- When there are only two objects interacting — direct reference is simpler
- When communication between components is simple and unidirectional

## Minimal Structure (TypeScript)

```typescript
interface ChatMediator {
  sendMessage(message: string, sender: ChatUser): void
}

class ChatRoom implements ChatMediator {
  private readonly users: ChatUser[] = []

  register(user: ChatUser): void { this.users.push(user) }

  sendMessage(message: string, sender: ChatUser): void {
    this.users
      .filter(user => user !== sender)
      .forEach(user => user.receive(message))
  }
}

class ChatUser {
  constructor(
    private readonly name: string,
    private readonly mediator: ChatMediator
  ) {}

  send(message: string): void { this.mediator.sendMessage(message, this) }
  receive(message: string): void { console.log(`${this.name} received: ${message}`) }
}
```

## Real Usage Example

```typescript
const room = new ChatRoom()
const alice = new ChatUser('Alice', room)
room.register(alice)
```

## Related to

- [observer.md](observer.md): complements — Observer defines one-to-many dependency; Mediator centralizes many-to-many communication
- [facade.md](facade.md): complements — both simplify relations; Facade simplifies interface to subsystem; Mediator coordinates objects that know each other mutually
- [rule 025 - Prohibition of Anti-Pattern The Blob](../../../rules/025_proibicao-anti-pattern-the-blob.md): reinforces — Mediator should not accumulate business logic, only coordinate
- [rule 070 - Prohibition of Shared Mutable State](../../../rules/070_proibicao-estado-mutavel-compartilhado.md): reinforces — Mediator centralizes communication, not shared state

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
