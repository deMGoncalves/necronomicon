# Data Clumps

**Severity:** 🟡 Medium
**Associated Rule:** Rule 053

## What It Is

Groups of data that always appear together in function parameters, class attributes, or local variables, but don't have their own object to represent them as a cohesive concept. They're primitives that always travel together but never got married.

## Symptoms

- Functions that always receive `(street, city, zipCode, country)` instead of an `Address`
- 3 or more parameters appear together in 2+ different functions
- Attributes that are always read/written together in a class
- Removing one data item from the group makes the others meaningless
- Validation of the same fields repeated in multiple locations

## ❌ Example (violation)

```javascript
// ❌ Address as 4 separate parameters in multiple functions
function createOrder(street, city, zipCode, country, productId, qty) { ... }
function validateShipping(street, city, zipCode, country) { ... }
function calculateFreight(street, city, zipCode, country) { ... }
```

## ✅ Refactoring

```javascript
// ✅ Address as cohesive object (Introduce Parameter Object)
class Address {
  constructor({ street, city, zipCode, country }) {
    if (!zipCode) throw new Error('ZIP code required');
    Object.assign(this, { street, city, zipCode, country });
  }
}

function createOrder(address, productId, qty) { ... }
function validateShipping(address) { ... }
function calculateFreight(address) { ... }
```

## Suggested Codetag

```typescript
// FIXME: Data Clumps — (street, city, zipCode, country) appear in 3+ functions
// TODO: Introduce Parameter Object: create Address class
```
