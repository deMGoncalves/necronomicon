# Rule 3 — Primitive Encapsulation

**deMGoncalves Rule:** CRIACIONAL-003
**Question:** Does this primitive represent a domain concept?

## What It Is

Requires that primitive types (such as `number`, `boolean`) and the `String` class that represent domain concepts (e.g., Email, CPF, Currency) be encapsulated in their own immutable Value Objects.

## When to Apply

- Method receives `string` for Email, CPF, URL
- Method receives `number` for Currency, Percentage, ID
- Method receives `string` repeatedly in same contexts
- Primitive validation is duplicated in multiple locations

## ❌ Violation

```typescript
class UserService {
  createUser(email: string, cpf: string): User {
    // Validation duplicated in multiple locations
    if (!email.includes('@')) throw new Error('Invalid email');
    if (cpf.length !== 11) throw new Error('Invalid CPF');
    // ...
  }
}
```

## ✅ Correct

```typescript
class Email {
  private readonly value: string;

  constructor(email: string) {
    if (!email.includes('@')) {
      throw new Error('Invalid email');
    }
    this.value = email;
    Object.freeze(this);
  }

  toString(): string {
    return this.value;
  }
}

class CPF {
  private readonly value: string;

  constructor(cpf: string) {
    if (cpf.length !== 11) {
      throw new Error('Invalid CPF');
    }
    this.value = cpf;
    Object.freeze(this);
  }

  toString(): string {
    return this.value;
  }
}

class UserService {
  createUser(email: Email, cpf: CPF): User {
    // Validation already done in Value Objects constructor
  }
}
```

## Exceptions

- **Generic Primitives**: Counters (`i`, `index`), control booleans (`isValid`), temporal deltas

## Related Rules

- [008 - No Getters/Setters Prohibition](rule-08-no-getters-setters.md): reinforces
- [009 - Tell, Don't Ask](rule-09-tell-dont-ask.md): reinforces
- [024 - No Magic Constants Prohibition](../../rules/024_proibicao-constantes-magicas.md): reinforces
