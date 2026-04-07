# Rule 2 — No ELSE Clause Prohibition

**deMGoncalves Rule:** COMPORTAMENTAL-002
**Question:** Does this method use `else` or `else if`?

## What It Is

Restricts the use of `else` and `else if` clauses, promoting replacement with guard clauses (early return) or polymorphism patterns to handle different execution paths.

## When to Apply

- Method contains `else` keyword
- Method contains `else if` keyword
- Type branching logic (if type === 'A')

## ❌ Violation

```typescript
class PaymentProcessor {
  processPayment(payment: Payment): void {
    if (payment.isValid()) {
      this.charge(payment);
    } else {
      this.logError(payment);  // ELSE - VIOLATES
    }
  }
}
```

## ✅ Correct

```typescript
class PaymentProcessor {
  processPayment(payment: Payment): void {
    if (!payment.isValid()) {
      this.logError(payment);
      return;  // Early return
    }
    this.charge(payment);
  }
}
```

## ✅ Correct (Polymorphism)

```typescript
interface PaymentStrategy {
  process(): void;
}

class CreditCardPayment implements PaymentStrategy {
  process(): void { /* ... */ }
}

class PayPalPayment implements PaymentStrategy {
  process(): void { /* ... */ }
}
```

## Exceptions

- **Switch statements**: As long as each `case` returns or terminates execution

## Related Rules

- [001 - Single Indentation Level](rule-01-single-indentation.md): reinforces
- [008 - No Getters/Setters Prohibition](rule-08-no-getters-setters.md): reinforces
- [011 - Open/Closed Principle](../../rules/011_principio-aberto-fechado.md): reinforces
