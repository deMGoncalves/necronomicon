# Prototype

**Category:** Creational
**Intent:** Specify the types of objects to create using a prototypical instance and create new objects by copying that prototype.

---

## When to Use

- Object creation is expensive (e.g., heavy initialization, configuration parsing)
- Need to create variations of an object without subclassing
- System should be independent of how its products are created and composed
- When working with objects that have complex initial state

## When NOT to Use

- When direct creation is simple enough (overengineering — rule 064)
- When the object contains circular references that are difficult to clone
- When shallow copy can introduce accidental mutation (rule 052)

## Minimal Structure (TypeScript)

```typescript
interface Cloneable<T> {
  clone(): T
}

class UserProfile implements Cloneable<UserProfile> {
  constructor(
    readonly name: string,
    readonly permissions: string[],
    readonly preferences: Record<string, unknown>
  ) {}

  // Creates deep copy of object
  clone(): UserProfile {
    return new UserProfile(
      this.name,
      [...this.permissions],
      { ...this.preferences }
    )
  }

  withName(name: string): UserProfile {
    const copy = this.clone()
    return new UserProfile(name, copy.permissions, copy.preferences)
  }
}
```

## Real Usage Example

```typescript
const adminProfile = baseProfile.clone()
const namedProfile = adminProfile.withName('admin')
```

## Related to

- [abstract-factory.md](abstract-factory.md): complements — Prototype can be used within Abstract Factory to create products by cloning
- [builder.md](builder.md): complements — Prototype can clone the final result of a Builder
- [rule 052 - Prohibition of Accidental Mutation](../../../rules/052_proibicao-mutacao-acidental.md): reinforces — shallow copies in objects with nested references cause accidental mutation
- [rule 029 - Object Immutability](../../../rules/029_imutabilidade-objetos-freeze.md): reinforces — clone and freeze ensures prototype immutability
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use when direct creation is sufficient

---

**GoF Category:** Creational
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
