# Observer

**Category:** Behavioral
**Intent:** Define one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

---

## When to Use

- Events and pub/sub between decoupled components
- Reactive programming and data binding
- State change notifications to multiple consumers
- Implement listeners and callbacks in structured way

## When NOT to Use

- When forgetting to `unsubscribe` causes memory leaks (rule 070 — Shared Mutable State)
- When the order of observer notification matters but isn't guaranteed
- For simple synchronous communication where direct call is clearer

## Minimal Structure (TypeScript)

```typescript
interface Observer<T> {
  update(data: T): void
}

class EventEmitter<T> {
  private readonly observers: Set<Observer<T>> = new Set()

  subscribe(observer: Observer<T>): void { this.observers.add(observer) }
  unsubscribe(observer: Observer<T>): void { this.observers.delete(observer) }

  notify(data: T): void {
    this.observers.forEach(observer => observer.update(data))
  }
}

class StockPrice extends EventEmitter<number> {
  private price = 0

  setPrice(price: number): void {
    this.price = price
    this.notify(price)
  }
}
```

## Real Usage Example

```typescript
const stock = new StockPrice()
stock.subscribe({ update: p => console.log('Price:', p) })
stock.setPrice(100)
```

## Related to

- [mediator.md](mediator.md): complements — Observer defines one-to-many dependency; Mediator centralizes many-to-many communication
- [chain-of-responsibility.md](chain-of-responsibility.md): complements — Observer notifies all; Chain stops at first handler that processes
- [rule 070 - Prohibition of Shared Mutable State](../../../rules/070_proibicao-estado-mutavel-compartilhado.md): reinforces — don't forget to `unsubscribe` to avoid memory leaks and obsolete references
- [rule 036 - Restriction of Functions with Side Effects](../../../rules/036_restricao-funcoes-efeitos-colaterais.md): complements — `notify()` has intentional and documented side effect

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
