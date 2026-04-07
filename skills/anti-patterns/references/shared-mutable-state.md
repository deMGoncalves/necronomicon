# Shared Mutable State

**Severity:** 🟠 High
**Associated Rule:** Rule 070

## What It Is

Multiple modules, functions or threads read and modify the same object without explicit coordination. Any part of the system can change state at any time, making program behavior unpredictable and difficult to trace.

## Symptoms

- Domain object passed by reference and modified in two or more distinct modules
- Module or global variable changed by multiple functions without explicit coordination
- Domain objects passed by reference and modified at various points
- Global or module variables changed by multiple functions
- Bugs that emerge far from modification point
- Tests that fail depending on execution order (sign of shared state)
- Array or object used as "communication buffer" between system parts without copying
- Different behavior between first and second call of same function

## ❌ Example (violation)

```javascript
// ❌ Shared and mutable cart state
const cart = { items: [], total: 0 };

function addItem(item) {
  cart.items.push(item);        // mutates global array
  cart.total += item.price;     // mutates global property
}

function applyDiscount(percent) {
  cart.total = cart.total * (1 - percent); // mutates again
}

// Who is responsible for cart.total now? Nobody knows for sure.
```

## ✅ Refactoring

```javascript
// ✅ Immutable state — each transformation returns new object
function addItem(cart, item) {
  return Object.freeze({
    items: [...cart.items, item],
    total: cart.total + item.price,
  });
}

function applyDiscount(cart, percent) {
  return Object.freeze({
    ...cart,
    total: cart.total * (1 - percent),
  });
}

// Each module receives and returns immutable versions — traceable and testable
const cart1 = addItem(emptyCart, item);
const cart2 = applyDiscount(cart1, 0.1);
```

## Suggested Codetag

```typescript
// FIXME: Shared Mutable State — cart mutated by multiple functions
// TODO: Make immutable: each function returns new object with Object.freeze()
```
