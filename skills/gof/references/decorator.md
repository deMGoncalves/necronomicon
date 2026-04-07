# Decorator

**Category:** Structural
**Intent:** Attach additional responsibilities to an object dynamically, as an alternative to subclassification for extending functionality.

---

## When to Use

- Add behaviors to individual objects without affecting other objects of the same class
- When inheritance would lead to subclass explosion
- To compose behaviors flexibly at runtime
- Cross-cutting concerns like logging, caching, validation, authentication

## When NOT to Use

- When stacking many Decorators makes debugging difficult (rule 060 — Spaghetti Code)
- When the order of Decorators is critical and difficult to control
- For behaviors that apply to the entire class, not individual instances

## Minimal Structure (TypeScript)

```typescript
interface DataSource {
  write(data: string): void
  read(): string
}

class FileDataSource implements DataSource {
  private content = ''
  write(data: string): void { this.content = data }
  read(): string { return this.content }
}

// Base Decorator
class DataSourceDecorator implements DataSource {
  constructor(protected readonly wrapped: DataSource) {}
  write(data: string): void { this.wrapped.write(data) }
  read(): string { return this.wrapped.read() }
}

// Concrete Decorator: adds compression
class CompressionDecorator extends DataSourceDecorator {
  write(data: string): void {
    const compressed = Buffer.from(data).toString('base64') // simulation
    this.wrapped.write(compressed)
  }
}
```

## Real Usage Example

```typescript
const source = new CompressionDecorator(new FileDataSource())
source.write('data')
```

## Related to

- [composite.md](composite.md): complements — Composite aggregates multiple objects; Decorator wraps a single object with additional behavior
- [proxy.md](proxy.md): complements — Proxy controls access; Decorator adds behavior; similar structure, different intent
- [strategy.md](strategy.md): complements — Strategy replaces algorithm via composition; Decorator adds behavior by stacking wrappers
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — adds behavior without modifying existing classes
- [rule 060 - Prohibition of Spaghetti Code](../../../rules/060_proibicao-codigo-spaghetti.md): reinforces — stacking many Decorators creates complexity difficult to follow

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
