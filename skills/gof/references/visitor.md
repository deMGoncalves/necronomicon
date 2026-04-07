# Visitor

**Category:** Behavioral
**Intent:** Represent an operation to be performed on elements of an object structure, allowing to define new operation without changing the classes of the elements.

---

## When to Use

- Execute operations on complex object structures (ASTs, document trees)
- Add operations to classes without modifying them (respects OCP)
- When there are distinct operations over a stable object hierarchy
- Reports, validations and transformations over heterogeneous structures

## When NOT to Use

- When the element hierarchy changes frequently — adding new type requires changing all Visitors
- For simple structures where direct polymorphism is sufficient
- When there's only one operation to execute over the structure

## Minimal Structure (TypeScript)

```typescript
interface Visitor {
  visitText(element: TextElement): string
  visitImage(element: ImageElement): string
}

interface DocumentElement {
  accept(visitor: Visitor): string
}

class TextElement implements DocumentElement {
  constructor(readonly content: string) {}
  accept(visitor: Visitor): string { return visitor.visitText(this) }
}

class ImageElement implements DocumentElement {
  constructor(readonly src: string) {}
  accept(visitor: Visitor): string { return visitor.visitImage(this) }
}

class HtmlExporter implements Visitor {
  visitText(el: TextElement): string { return `<p>${el.content}</p>` }
  visitImage(el: ImageElement): string { return `<img src="${el.src}" />` }
}
```

## Real Usage Example

```typescript
const exporter = new HtmlExporter()
elements.map(el => el.accept(exporter)).join('')
```

## Related to

- [composite.md](composite.md): complements — Visitor frequently applied over Composite structures to execute distinct operations
- [iterator.md](iterator.md): complements — Iterator traverses structure; Visitor executes operation on each element
- [interpreter.md](interpreter.md): complements — Visitor can traverse the Interpreter's expression tree
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new operation via new Visitor without changing element classes
- [rule 010 - Single Responsibility Principle](../../../rules/010_principio-responsabilidade-unica.md): reinforces — each Visitor has a single operation responsibility

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
