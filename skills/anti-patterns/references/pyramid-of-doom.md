# Pyramid of Doom (Arrow Anti-Pattern)

**Severity:** 🟠 High
**Associated Rule:** Rule 066

## What It Is

Excessive nesting of conditionals (`if`/`else`) and loops that creates a pyramid or arrow-shaped visual structure. Each nesting level adds cognitive complexity and increases Cyclomatic Complexity Index.

## Symptoms

- Code with 4 or more indentation levels
- `if` inside `if` inside `for` inside `if`
- To understand the happy path, you need to read all nesting levels
- CC (Cyclomatic Complexity) > 10

## ❌ Example (violation)

```javascript
// ❌ Pyramid — happy path buried at level 4
function processOrder(order) {
  if (order) {
    if (order.items.length > 0) {
      if (order.user.isActive) {
        if (order.payment.isValid) {
          return fulfill(order); // happy path at level 4
        } else {
          return { error: 'Invalid payment' };
        }
      } else {
        return { error: 'Inactive user' };
      }
    } else {
      return { error: 'Empty order' };
    }
  } else {
    return { error: 'Order not found' };
  }
}
```

## ✅ Refactoring

```javascript
// ✅ Guard clauses — happy path at level zero
function processOrder(order) {
  if (!order) return { error: 'Order not found' };
  if (order.items.length === 0) return { error: 'Empty order' };
  if (!order.user.isActive) return { error: 'Inactive user' };
  if (!order.payment.isValid) return { error: 'Invalid payment' };

  return fulfill(order);
}
```

## Suggested Codetag

```typescript
// FIXME: Pyramid of Doom — 4 nesting levels
// TODO: Apply Guard Clauses to linearize flow
```
