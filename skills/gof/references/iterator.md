# Iterator

**Category:** Behavioral
**Intent:** Provide a way to access elements of an aggregate object sequentially without exposing its underlying representation.

---

## When to Use

- Traverse collections without exposing internal structure
- Support multiple ways to traverse the same collection
- Provide uniform interface to traverse different structures
- In JavaScript/TypeScript, implement `Symbol.iterator` protocol

## When NOT to Use

- When the collection is simple and native arrays with `for...of` are sufficient
- When manually creating Iterator class adds complexity without gain — in modern JS/TS, prefer native `Symbol.iterator` protocol
- For traversal of structures that already expose adequate iteration APIs

## Minimal Structure (TypeScript)

```typescript
class Range implements Iterable<number> {
  constructor(
    private readonly start: number,
    private readonly end: number,
    private readonly step = 1
  ) {}

  [Symbol.iterator](): Iterator<number> {
    let current = this.start
    const { end, step } = this

    return {
      next(): IteratorResult<number> {
        if (current <= end) {
          const value = current
          current += step
          return { value, done: false }
        }
        return { value: undefined as never, done: true }
      }
    }
  }
}
```

## Real Usage Example

```typescript
for (const n of new Range(1, 10, 2)) {
  console.log(n) // 1, 3, 5, 7, 9
}
```

## Related to

- [composite.md](composite.md): complements — Iterator frequently used to traverse Composite structures
- [visitor.md](visitor.md): complements — Visitor can use Iterator to traverse collection elements
- [rule 004 - First Class Collections](../../../rules/004_colecoes-primeira-classe.md): complements — Iterator implements traversal behavior encapsulated in collection
- [rule 008 - Prohibition of Getters and Setters](../../../rules/008_proibicao-getters-setters.md): reinforces — Iterator exposes traversal behavior, not collection's internal state

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
