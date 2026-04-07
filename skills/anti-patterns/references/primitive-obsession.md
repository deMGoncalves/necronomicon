# Primitive Obsession

**Severity:** 🔴 Critical
**Associated Rule:** Rule 003

## What It Is

Using primitive types (`string`, `number`, `boolean`) to represent domain concepts that should be objects with their own behavior. ZIP code as `string`, money as `number`, status as `boolean`.

## Symptoms

- Parameters like `(string email, string phone, string zipCode)` instead of objects
- Validation of same format scattered in various places (`/\d{8}/` for ZIP code)
- Magic Numbers representing states: `status === 1`, `type === 'A'`
- Arrays of primitives where objects would be more descriptive

## ❌ Example (violation)

```javascript
// ❌ CPF as loose string — duplicated validation in N places
function createUser(name, cpf, email) {
  if (!/^\d{11}$/.test(cpf)) throw new Error('Invalid CPF');
  // ... same validation in updateUser, validateDocument, etc.
}
```

## ✅ Refactoring

```javascript
// ✅ CPF as Value Object — validation encapsulated once
class CPF {
  constructor(value) {
    if (!/^\d{11}$/.test(value)) throw new Error('Invalid CPF');
    this.value = value;
  }
  format() { return `${this.value.slice(0,3)}.${this.value.slice(3,6)}.${this.value.slice(6,9)}-${this.value.slice(9)}`; }
}

function createUser(name, cpf, email) {
  // CPF already validated — whoever instantiates CPF ensures validity
}
```

## Suggested Codetag

```typescript
// FIXME: Primitive Obsession — CPF as string without encapsulation
// TODO: Create CPF Value Object with validation in constructor
```
