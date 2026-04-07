# Composite

**Category:** Structural
**Intent:** Compose objects into tree structures to represent part-whole hierarchies, allowing clients to treat individual objects and compositions uniformly.

---

## When to Use

- Hierarchical structures like UI component trees, file systems, menus
- When clients need to ignore the difference between compositions and individual objects
- To represent recursive structures naturally
- In parsers and ASTs (Abstract Syntax Trees)

## When NOT to Use

- For structures that are not naturally hierarchical (overengineering — rule 064)
- When the distinction between leaf and composition is important to the client
- When operations differ significantly between leaves and composite nodes

## Minimal Structure (TypeScript)

```typescript
interface MenuComponent {
  render(): string
  getPrice(): number
}

class MenuItem implements MenuComponent {
  constructor(
    private readonly name: string,
    private readonly price: number
  ) {}

  render(): string { return `${this.name}: R$${this.price}` }
  getPrice(): number { return this.price }
}

class MenuCategory implements MenuComponent {
  private readonly items: MenuComponent[] = []

  constructor(private readonly name: string) {}

  add(item: MenuComponent): void { this.items.push(item) }

  render(): string {
    const children = this.items.map(item => item.render()).join('\n')
    return `${this.name}:\n${children}`
  }

  getPrice(): number {
    return this.items.reduce((sum, item) => sum + item.getPrice(), 0)
  }
}
```

## Real Usage Example

```typescript
const menu = new MenuCategory('Sandwiches')
menu.add(new MenuItem('Hamburger', 25))
```

## Related to

- [decorator.md](decorator.md): complements — Decorator adds responsibilities to a single object; Composite aggregates objects in tree
- [iterator.md](iterator.md): complements — Iterator frequently used to traverse Composite structures
- [visitor.md](visitor.md): complements — Visitor frequently applied over Composite structures to execute operations
- [rule 004 - First Class Collections](../../../rules/004_colecoes-primeira-classe.md): complements — MenuCategory encapsulates collection with domain behavior
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use for non-hierarchical structures

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
