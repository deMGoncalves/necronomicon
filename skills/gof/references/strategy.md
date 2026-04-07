# Strategy

**Category:** Behavioral
**Intent:** Define a family of algorithms, encapsulate each one, and make them interchangeable, allowing the algorithm to vary independently from clients that use it.

---

## When to Use

- Switch algorithm at runtime (e.g., different sorting, compression, calculation strategies)
- Eliminate `if/switch` that select behavior by type
- When multiple variants of an algorithm exist
- To isolate variable business logic from the code that uses it

## When NOT to Use

- When there's only one fixed algorithm — use directly without encapsulating (overengineering — rule 064)
- When algorithm variation is rare and simple `if` is more readable
- Prefer Strategy over Template Method when wanting composition instead of inheritance

## Minimal Structure (TypeScript)

```typescript
interface SortStrategy<T> {
  sort(data: T[]): T[]
}

class BubbleSortStrategy<T> implements SortStrategy<T> {
  sort(data: T[]): T[] {
    const arr = [...data]
    for (let i = 0; i < arr.length; i++) {
      for (let j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]]
        }
      }
    }
    return arr
  }
}

class NativeSortStrategy<T> implements SortStrategy<T> {
  sort(data: T[]): T[] { return [...data].sort() }
}

class Sorter<T> {
  constructor(private strategy: SortStrategy<T>) {}

  setStrategy(strategy: SortStrategy<T>): void { this.strategy = strategy }
  sort(data: T[]): T[] { return this.strategy.sort(data) }
}
```

## Real Usage Example

```typescript
const sorter = new Sorter(new NativeSortStrategy())
sorter.sort([3, 1, 2])
```

## Related to

- [state.md](state.md): complements — Strategy switches algorithm manually; State transitions behavior automatically based on state
- [template-method.md](template-method.md): replaces — Strategy uses composition; Template Method uses inheritance; prefer Strategy when wanting to avoid inheritance
- [decorator.md](decorator.md): complements — Decorator adds behavior by stacking; Strategy replaces central behavior
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new strategy without modifying Sorter
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — Sorter depends on SortStrategy interface, not on concrete implementations
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use when there's only one algorithm

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
