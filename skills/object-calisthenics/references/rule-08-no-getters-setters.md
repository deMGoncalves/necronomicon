# Rule 8 — No Getters/Setters Prohibition

**deMGoncalves Rule:** COMPORTAMENTAL-008
**Question:** Is this method a pure getter/setter without business logic?

## What It Is

Prohibits the creation of methods purely for accessing or directly modifying the internal state of the object (such as `getProperty()` and `setProperty()`), reinforcing encapsulation and the "Tell, Don't Ask" principle.

## When to Apply

- Method with name `getXxx()` that only returns attribute
- Method with name `setXxx()` that only assigns value
- Method that exposes internal state without transformation
- Client deciding logic based on getter

## ❌ Violation

```typescript
class Order {
  private status: string;
  private items: Item[];

  getStatus(): string {  // VIOLATES: pure getter
    return this.status;
  }

  setStatus(status: string): void {  // VIOLATES: pure setter
    this.status = status;
  }

  getItems(): Item[] {  // VIOLATES: exposes internal collection
    return this.items;
  }
}

// Client deciding logic - VIOLATES Tell, Don't Ask
if (order.getStatus() === 'pending') {
  order.setStatus('processing');
}
```

## ✅ Correct

```typescript
class Order {
  private status: OrderStatus;
  private items: OrderItemList;

  startProcessing(): void {  // Intention method
    if (!this.status.isPending()) {
      throw new Error('Cannot process non-pending order');
    }
    this.status = OrderStatus.processing();
  }

  addItem(item: Item): void {  // Behavior method
    this.items.add(item);
  }

  getTotalValue(): number {  // Transformation/calculation is OK
    return this.items.getTotalValue();
  }
}

// Client telling what to do - CORRECT
order.startProcessing();
```

## Exceptions

- **DTOs**: Pure classes for data transfer
- **Serialization Frameworks**: Libraries that require getters/setters

## Related Rules

- [009 - Tell, Don't Ask](rule-09-tell-dont-ask.md): reinforces
- [003 - Primitive Encapsulation](rule-03-wrap-primitives.md): complements
- [004 - First Class Collections](rule-04-first-class-collections.md): reinforces
