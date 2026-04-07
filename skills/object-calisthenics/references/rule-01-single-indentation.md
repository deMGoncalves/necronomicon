# Rule 1 — Single Indentation Level

**deMGoncalves Rule:** ESTRUTURAL-001
**Question:** Does this method have more than one indentation level after the initial scope?

## What It Is

Limits the complexity of a method or function by imposing a single indentation level for code blocks (conditionals, loops or try-catch), forcing the extraction of logic into separate methods.

## When to Apply

- Method has `if` inside `for`
- Method has `for` inside `if`
- Method has nested callbacks
- Cyclomatic Complexity > 5

## ❌ Violation

```typescript
class OrderProcessor {
  processOrders(orders: Order[]): void {
    for (const order of orders) {
      if (order.isValid()) {
        if (order.isPaid()) {
          // Three indentation levels - VIOLATES
          this.shipOrder(order);
        }
      }
    }
  }
}
```

## ✅ Correct

```typescript
class OrderProcessor {
  processOrders(orders: Order[]): void {
    for (const order of orders) {
      this.processOrder(order);  // One indentation level
    }
  }

  private processOrder(order: Order): void {
    if (!order.isValid()) return;  // Guard clause
    if (!order.isPaid()) return;   // Guard clause
    this.shipOrder(order);
  }
}
```

## Exceptions

- **Try/Catch/Finally**: Error handling that cannot be delegated
- **Guard Clauses**: Early returns don't count as new level

## Related Rules

- [002 - No ELSE Prohibition](rule-02-no-else.md): reinforces
- [007 - Small Classes](rule-07-small-classes.md): complements
- [022 - Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): reinforces
