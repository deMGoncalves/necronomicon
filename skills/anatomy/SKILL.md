---
name: anatomy
description: Convention for organizing members within a class. Use when creating or refactoring classes, Web Components, or JavaScript modules — whenever the declaration order of members needs to be validated or corrected.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Anatomy

Convention for organizing members within a class.

---

## When to Use

Use when creating or refactoring classes to order members correctly.

## Structure

| Order | Member | Ordering |
|-------|--------|-----------|
| 1 | Private members (`#name`) | Alphabetical |
| 2 | Getters and Setters | Alphabetical |
| 3 | Static Getters and Setters | Alphabetical |
| 4 | Constructor | - |
| 5 | Methods | Alphabetical |
| 6 | Static Methods | Alphabetical |
| 7 | `static {}` Block | - |

## Additional Rules

- Getters and setters of the same name stay together (getter first)
- Within each group, order alphabetically by name
- Private members use `#` prefix

## Examples

```typescript
// ❌ Bad — incorrect order
class UserService {
  constructor(private repo: UserRepository) {}

  get name() { return this.#name }

  #name = ''

  findById(id: string) { return this.repo.find(id) }

  static create() { return new UserService(new UserRepository()) }
}

// ✅ Good — following Anatomy
class UserService {
  // 1. Private
  #name = ''

  // 2. Getters/Setters
  get name() { return this.#name }

  // 3. Constructor
  constructor(private repo: UserRepository) {}

  // 4. Methods
  findById(id: string) { return this.repo.find(id) }

  // 5. Static
  static create() { return new UserService(new UserRepository()) }
}
```

## Prohibitions

| What to avoid | Reason |
|--------------|-------|
| Ordering methods by usage or frequency | Makes locating difficult, use alphabetical order (rule 022) |
| Mixing private and public members | Clear separation facilitates understanding (rule 010) |
| Placing getters and setters in different locations | Getter/setter pair should stay together for cohesion |
| Class with more than 50 lines | Violates rule 007, extract responsibilities |

## Rationale

- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): predictable code reduces cognitive cost, consistent structure facilitates reading
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): organization facilitates identifying responsibilities of each member
- [007 - Line Restriction in Classes](../../rules/007_restricao-linhas-classes.md): class with maximum of 50 lines, methods with maximum of 15 lines
