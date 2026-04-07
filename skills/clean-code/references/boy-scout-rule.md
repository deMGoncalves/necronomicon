# Boy Scout Rule (Rule 039)

## Rule

- **039**: Always leave code better than you found it

## Checklist

- [ ] Small code smells fixed in alteration scope
- [ ] Modified files with CC>5 → refactor
- [ ] Bad names → rename during alteration
- [ ] Missing guard clauses → add
- [ ] PR diff shows improvements beyond requested

## Philosophy

> "Leave the campground cleaner than you found it."

Continuous and emergent refactoring prevents technical debt accumulation. Don't wait for "refactoring sprint" — improve whenever touching code.

## Examples

```typescript
// Before (found)
function processOrder(order) {
  if (order.status == 'pending') {
    if (order.items.length > 0) {
      if (order.payment === 'card') {
        if (order.amount > 1000) {
          return applyDiscount(order)
        } else {
          return processPayment(order)
        }
      } else if (order.payment === 'pix') {
        return processPix(order)
      }
    }
  }
  return false;
}

// After (improved while passing through)
function processOrder(order: Order): boolean {
  // Guard clauses added
  if (order.status !== OrderStatus.PENDING) return false;
  if (order.total <= 0) return false;
  if (!order.user) return false;

  // Main logic
  order.status = OrderStatus.PROCESSING;
  saveOrder(order);
  return true;
}

function processCardPayment(order: Order): string {
  return order.amount > 1000 ? applyDiscount(order) : processPayment(order);
}

// Enums created where there were magic strings
enum OrderStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed'
}
```

## Scouting Opportunities

| Found | Scouting Action |
|-------|-----------------|
| `if (x) { if (y) { ... } }` | Apply guard clause or extract method |
| `strName`, `bIsActive` | Remove Hungarian notation |
| `const val = 100` | Create named constant (`MAX_RETRIES`) |
| Method with CC=6 | Extract conditionals into private methods |
| Redundant comment | Remove or transform into WHY |
| `return null` | Throw domain exception |

## When NOT to Apply

- **Critical Hotfixes**: Refactoring risk > immediate gain
- **Untested Code**: Without tests, refactoring can introduce bugs
- **Too distant scope**: Don't refactor files unrelated to PR

## Relation to ICP

- Reduces technical debt incrementally
- Keeps CC_base and Responsibilities under control
- Prevents Blob and Lava Flow formation
