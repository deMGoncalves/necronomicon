# Refactoring Techniques to Reduce CC

## Techniques by Problem

| High CC Due To | Technique | How to Apply |
|----------------|-----------|--------------|
| Nested conditionals | Guard clauses | Invert condition and return early |
| Switch/if-else of types | Polymorphism | Create subclasses or Strategy pattern |
| Complex logic in long method | Method extraction | Name subproblems as methods |
| Loops with internal logic | Higher-order functions | Use `.filter()`, `.map()`, `.reduce()` |
| Multiple boolean conditions | Encapsulation | Create `isX()` method that encapsulates the condition |
| Complex recursion | Iteration with stack | Replace with explicit loop |

## Example: Guard Clauses

```typescript
// ❌ Before — CC = 6 (deep nesting)
function process(order: Order): string {
  if (order !== null) {
    if (order.status === 'active') {
      if (order.items.length > 0) {
        if (order.total > 0) {
          return calculateFee(order)
        }
      }
    }
  }
  return 'invalid'
}

// ✅ After — CC = 4 (guard clauses)
function process(order: Order): string {
  if (order === null) return 'invalid'
  if (order.status !== 'active') return 'invalid'
  if (order.items.length === 0) return 'invalid'
  if (order.total <= 0) return 'invalid'
  return calculateFee(order)
}
```

## Example: Method Extraction

```typescript
// ❌ Before — CC = 7 in a single method
function validate(user: User): boolean {
  if (!user.name || user.name.length < 2) return false
  if (!user.email || !user.email.includes('@')) return false
  if (!user.age || user.age < 18 || user.age > 120) return false
  // ... more conditions
}

// ✅ After — CC ≤ 3 per method
function validate(user: User): boolean {
  return hasValidName(user) && hasValidEmail(user) && hasValidAge(user)
}
function hasValidName(user: User): boolean {
  return Boolean(user.name && user.name.length >= 2)
}
```
