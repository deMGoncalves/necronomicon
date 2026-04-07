# Template Method

**Category:** Behavioral
**Intent:** Define the skeleton of an algorithm in an operation, deferring definition of some steps to subclasses, without changing the algorithm structure.

---

## When to Use

- Algorithm with fixed structure but variable steps between subclasses
- Avoid duplication when multiple classes have similar algorithms with small differences
- Implement optional hooks in frameworks
- When clients should be able to extend specific parts, not the entire structure

## When NOT to Use

- When inheritance can be replaced by composition — prefer Strategy (rule 059 — Refused Bequest)
- When subclasses need to alter the algorithm structure, not just steps
- For extension where inheritance would cause subclass explosion

## Minimal Structure (TypeScript)

```typescript
abstract class ReportGenerator {
  // Template Method: defines the algorithm skeleton
  generate(data: unknown[]): string {
    const header = this.renderHeader()
    const body = this.renderBody(data)
    const footer = this.renderFooter()
    return `${header}\n${body}\n${footer}`
  }

  protected abstract renderBody(data: unknown[]): string

  // Optional hooks with default implementation
  protected renderHeader(): string { return '=== Report ===' }
  protected renderFooter(): string { return '=== End ===' }
}

class CSVReport extends ReportGenerator {
  protected renderBody(data: unknown[]): string {
    return data.map(row => Object.values(row as object).join(',')).join('\n')
  }
}
```

## Real Usage Example

```typescript
new CSVReport().generate([{ name: 'Alice', age: 30 }])
```

## Related to

- [factory-method.md](factory-method.md): complements — Factory Method is frequently a step in Template Method
- [strategy.md](strategy.md): replaces — Strategy uses composition; Template Method uses inheritance; prefer Strategy to avoid inheritance coupling
- [rule 059 - Prohibition of Refused Bequest](../../../rules/059_proibicao-heranca-refusao.md): reinforces — subclasses should not override the template method, only the abstract steps
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new variant without changing base algorithm

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
