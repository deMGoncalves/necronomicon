# Bridge

**Category:** Structural
**Intent:** Decouple an abstraction from its implementation so both can vary independently.

---

## When to Use

- Abstraction and implementation should be extensible by subclassification
- Changes in implementation should not impact abstraction clients
- When having class explosion due to inheritance in two independent variation axes
- To hide implementation details from clients

## When NOT to Use

- When there's only one possible implementation (overengineering — rule 064)
- When abstraction and implementation don't vary independently
- For simple problems where direct composition is sufficient

## Minimal Structure (TypeScript)

```typescript
// Implementation (can vary)
interface Renderer {
  renderCircle(radius: number): string
}

class SVGRenderer implements Renderer {
  renderCircle(radius: number): string {
    return `<circle r="${radius}" />`
  }
}

class CanvasRenderer implements Renderer {
  renderCircle(radius: number): string {
    return `ctx.arc(0, 0, ${radius}, 0, 2 * Math.PI)`
  }
}

// Abstraction (can vary independently from implementation)
class Shape {
  constructor(protected readonly renderer: Renderer) {}
}

class Circle extends Shape {
  constructor(private readonly radius: number, renderer: Renderer) {
    super(renderer)
  }

  draw(): string {
    return this.renderer.renderCircle(this.radius)
  }
}
```

## Real Usage Example

```typescript
new Circle(50, new SVGRenderer()).draw()
```

## Related to

- [adapter.md](adapter.md): complements — Adapter reconciles existing interfaces; Bridge separates abstraction from implementation from design
- [abstract-factory.md](abstract-factory.md): complements — Abstract Factory can create implementation objects for Bridge
- [strategy.md](strategy.md): complements — Strategy replaces algorithm at runtime; Bridge separates hierarchies permanently
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — abstraction depends on Renderer interface, not on concrete implementations
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new shapes or renderers without modifying existing code
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use when there's only one implementation

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
