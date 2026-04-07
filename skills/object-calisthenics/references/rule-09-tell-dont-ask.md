# Rule 9 — Tell, Don't Ask

**deMGoncalves Rule:** COMPORTAMENTAL-009
**Question:** Does this code ask for state to decide action?

## What It Is

Requires that a method call methods or access properties only from its "immediate neighbors": the object itself, objects passed as arguments, objects it creates, or objects that are direct internal properties.

**Principle**: Tell the object what to do, don't ask for its state to make decisions.

## When to Apply

- Code asks for state: `if (obj.getStatus() === 'X')`
- Code decides action based on another object's state
- Train wreck: `a.getB().getC().f()`
- Law of Demeter violation

## ❌ Violation

```typescript
class OrderProcessor {
  process(order: Order): void {
    // ASKS state to decide - VIOLATES
    if (order.getStatus() === 'pending') {
      if (order.getPayment().isPaid()) {
        order.setStatus('processing');
        order.getCustomer().sendEmail('Order processing');
      }
    }
  }
}
```

## ✅ Correct

```typescript
class OrderProcessor {
  process(order: Order): void {
    // TELLS object what to do
    order.processIfReady();
  }
}

class Order {
  processIfReady(): void {
    if (!this.status.isPending()) return;
    if (!this.payment.isPaid()) return;

    this.status = OrderStatus.processing();
    this.customer.notifyProcessing();
  }
}
```

## ✅ Correct (Even Better)

```typescript
class Order {
  processIfReady(): void {
    // Each object has its own responsibility
    this.validateCanProcess();
    this.startProcessing();
    this.notifyCustomer();
  }

  private validateCanProcess(): void {
    if (!this.status.isPending()) {
      throw new InvalidStatusError();
    }
    if (!this.payment.isPaid()) {
      throw new UnpaidOrderError();
    }
  }

  private startProcessing(): void {
    this.status = OrderStatus.processing();
  }

  private notifyCustomer(): void {
    this.customer.notifyProcessing();
  }
}
```

## Exceptions

- **Fluent Interfaces**: Builders where method returns `this`
- **DTOs/Value Objects**: Access to data from pure containers

## Related Rules

- [008 - No Getters/Setters Prohibition](rule-08-no-getters-setters.md): reinforces
- [005 - One Dot per Line](rule-05-one-dot-per-line.md): reinforces
- [012 - Liskov Substitution Principle](../../rules/012_principio-substituicao-liskov.md): reinforces
