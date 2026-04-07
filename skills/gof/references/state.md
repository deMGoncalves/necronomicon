# State

**Category:** Behavioral
**Intent:** Allow an object to alter its behavior when its internal state changes, appearing to change its class.

---

## When to Use

- State machines with well-defined transitions
- Workflows with distinct states (pending, active, completed, cancelled)
- Objects whose behavior strongly depends on current state
- To eliminate large blocks of `if/switch` based on state

## When NOT to Use

- When there are only 2-3 simple states — `if/switch` may be clearer (rule 022 — KISS)
- When state transitions are rare and class overhead isn't justified
- When preferring Strategy — State is better for automatic state transitions; Strategy for manual algorithm switching

## Minimal Structure (TypeScript)

```typescript
interface OrderState {
  confirm(order: Order): void
  ship(order: Order): void
  cancel(order: Order): void
}

class PendingState implements OrderState {
  confirm(order: Order): void { order.setState(new ConfirmedState()) }
  ship(_: Order): void { throw new Error('Confirm before shipping') }
  cancel(order: Order): void { order.setState(new CancelledState()) }
}

class ConfirmedState implements OrderState {
  confirm(_: Order): void { throw new Error('Order already confirmed') }
  ship(order: Order): void { order.setState(new ShippedState()) }
  cancel(order: Order): void { order.setState(new CancelledState()) }
}

class Order {
  private state: OrderState = new PendingState()
  setState(state: OrderState): void { this.state = state }
  confirm(): void { this.state.confirm(this) }
  ship(): void { this.state.ship(this) }
  cancel(): void { this.state.cancel(this) }
}

class ShippedState implements OrderState {
  confirm(_: Order): void { throw new Error('Order already shipped') }
  ship(_: Order): void { throw new Error('Order already shipped') }
  cancel(_: Order): void { throw new Error('Cannot cancel shipped order') }
}

class CancelledState implements OrderState {
  confirm(_: Order): void { throw new Error('Order cancelled') }
  ship(_: Order): void { throw new Error('Order cancelled') }
  cancel(_: Order): void { throw new Error('Order already cancelled') }
}
```

## Real Usage Example

```typescript
const order = new Order()
order.confirm()
order.ship()
```

## Related to

- [strategy.md](strategy.md): complements — State transitions automatically between behaviors; Strategy allows manual algorithm switching
- [memento.md](memento.md): complements — Memento can save and restore State machine states
- [rule 002 - Prohibition of ELSE Clause](../../../rules/002_proibicao-clausula-else.md): reinforces — State eliminates if/else based on current state
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new state without modifying existing logic
- [rule 022 - Prioritization of Simplicity and Clarity](../../../rules/022_priorizacao-simplicidade-clareza.md): reinforces — don't use State for 2-3 simple states where if is clearer

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
