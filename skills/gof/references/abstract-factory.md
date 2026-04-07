# Abstract Factory

**Category:** Creational
**Intent:** Provide an interface for creating families of related objects without specifying concrete classes.

---

## When to Use

- System needs to be independent of how its products are created
- System should work with multiple families of objects
- When building UI that needs themes (light/dark) or different platforms
- When products in a family should be used together

## When NOT to Use

- When there's only one product family — Factory Method is sufficient
- When adding new product types requires changing the entire interface (high cost)
- For unrelated objects (overengineering — rule 064)

## Minimal Structure (TypeScript)

```typescript
interface Button { render(): string }
interface Input { render(): string }

interface UIFactory {
  createButton(): Button
  createInput(): Input
}

class MaterialUIFactory implements UIFactory {
  createButton(): Button {
    return { render: () => '<button class="material">...</button>' }
  }
  createInput(): Input {
    return { render: () => '<input class="material" />' }
  }
}

class BootstrapUIFactory implements UIFactory {
  createButton(): Button {
    return { render: () => '<button class="btn">...</button>' }
  }
  createInput(): Input {
    return { render: () => '<input class="form-control" />' }
  }
}
```

## Real Usage Example

```typescript
const factory: UIFactory = new MaterialUIFactory()
factory.createButton().render()
```

## Related to

- [factory-method.md](factory-method.md): depends — Abstract Factory is composed of Factory Methods
- [builder.md](builder.md): complements — Builder builds a complex product; Abstract Factory creates families
- [prototype.md](prototype.md): complements — Prototype can be used within Abstract Factory to create products by cloning
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — clients depend on UIFactory interface, not on concrete classes
- [rule 011 - Open/Closed Principle](../../../rules/011_principio-aberto-fechado.md): reinforces — add new family without modifying existing clients

---

**GoF Category:** Creational
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
