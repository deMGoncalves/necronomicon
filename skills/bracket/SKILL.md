---
name: bracket
description: Convention for Symbol for private methods and contracts. Use when defining private methods in Web Components, when creating interface contracts via Symbol, or when reviewing code that uses string-based naming for privacy.
model: sonnet
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Bracket

Convention for Symbol for private methods and interface contracts.

---

## When to Use

Use when creating methods that need decorators or defining interfaces for mixins.

## Principle

| Principle | Description |
|-----------|-----------|
| Encapsulation | Symbol creates unique and private keys for methods and contracts |
| Extensibility | Allows defining interface contracts without name conflicts |

## Rules

| Rule | Description |
|-------|-----------|
| Ownership | The module owning the concept defines the Symbol |
| Locality | Prefer local `Symbol()` over global `Symbol.for()` |
| Export | Export only Symbols that are public contracts |

## Structure

| File | Purpose |
|---------|-----------|
| `interfaces.js` | Exports module's Symbols |

## Types

| Type | Syntax | Usage |
|------|---------|-----|
| Local | `Symbol('name')` | Private to module |
| Global | `Symbol.for('name')` | Shared via registry |

## Naming

| Type | Convention | Example |
|------|-----------|---------|
| Callback | `verbCallback` | `didPaintCallback` |
| Action | `verbNoun` | `connectArc` |
| Capability | `adjective` | `hideable` |
| Resource | `noun` | `controller` |

## Examples

```typescript
// ❌ Bad — privacy by weak convention
class MyComponent extends HTMLElement {
  _privateMethod() { /* not really private */ }
  __init() { /* fragile convention */ }
}

// ✅ Good — privacy via Symbol
const render = Symbol('render')
const init = Symbol('init')

class MyComponent extends HTMLElement {
  [render]() { /* true private method via Symbol */ }
  [init]() { /* controlled access */ }
}
```

## Prohibitions

| What to avoid | Reason |
|--------------|-------|
| Using Symbol.for() unnecessarily | Local Symbol is safer, use global only for cross-module contracts |
| Symbol without description | Makes debugging difficult, always pass descriptive string |
| Exporting private Symbols | Expose only public interface contracts (rule 013) |
| Generic names in Symbols | Use descriptive names that reveal intent (rule 006) |

## Rationale

- [008 - Prohibition of Pure Getters/Setters](../../rules/008_proibicao-getters-setters-puros.md): Symbol allows true encapsulation instead of getters/setters for access to internal methods
- [013 - Interface Segregation Principle](../../rules/013_principio-segregacao-interfaces.md): specific contracts via Symbol allow granular and decoupled interfaces
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each Symbol represents a single contract or behavior
