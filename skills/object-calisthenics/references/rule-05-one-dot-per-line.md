# Rule 5 — One Dot per Line

**deMGoncalves Rule:** ESTRUTURAL-005
**Question:** Does this line have multiple chained accesses (dots)?

## What It Is

Limits the chaining of method calls and chained property access (train wrecks), allowing at most one method call or property access per line.

## When to Apply

- Line contains `a.b().c()`
- Line contains `object.getA().getB()`
- Code violates Law of Demeter
- Train wreck: `user.getAddress().getCity().getName()`

## ❌ Violation

```typescript
class OrderProcessor {
  process(order: Order): void {
    // Three dots on same line - VIOLATES
    const cityName = order.getCustomer().getAddress().getCity();

    // Violates Law of Demeter
    order.getPayment().getCard().charge();
  }
}
```

## ✅ Correct

```typescript
class OrderProcessor {
  process(order: Order): void {
    // Tell, Don't Ask: tell the object what to do
    order.processPayment();

    // Or break into separate lines with clear intent
    const customer = order.getCustomer();
    const cityName = customer.getCityName();
  }
}
```

## ✅ Correct (Better Approach)

```typescript
class Order {
  processPayment(): void {
    this.payment.charge();  // Encapsulates internal access
  }

  getCustomerCityName(): string {
    return this.customer.getCityName();  // Delegates responsibility
  }
}
```

## Exceptions

- **Fluent Interfaces/Builders**: `new Query().where().limit()` where each method returns `this`
- **Static Constants**: `Math.PI`, `Config.MAX_VALUE`

## Related Rules

- [009 - Tell, Don't Ask](rule-09-tell-dont-ask.md): reinforces
- [008 - No Getters/Setters Prohibition](rule-08-no-getters-setters.md): reinforces
- [022 - Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): complements
