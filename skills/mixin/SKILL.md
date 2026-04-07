---
name: mixin
description: Convention for using mixins for behavior composition in Web Components. Use when creating or modifying components that need reusable functionalities, composing behaviors without multiple inheritance, or reviewing code with bloated base classes.
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Mixin

Convention for using mixins for behavior composition.

---

## When to Use

Use when creating or modifying components that need reusable functionalities.

## Principle

| Principle | Description |
|-----------|-------------|
| Composition | Add behaviors through composition, not inheritance |
| Reuse | Share functionalities between different components |

## Available Mixins

| Mixin | Purpose | Functionality |
|-------|---------|---------------|
| Align | Alignment | Controls content alignment |
| Color | Coloring | Manages component color scheme |
| Disabled | Disabling | Adds disabled state |
| Headless | Invisibility | Removes component visualization |
| Height | Height | Controls vertical dimension |
| Hidden | Visibility | Manages component visibility |
| Reaval | Revelation | Auto-scroll behavior |
| Width | Width | Controls horizontal dimension |

## Application

| Aspect | Description |
|--------|-------------|
| Order | Applied from right to left |
| Base | Always start with base class (HTMLElement or Echo) |
| Chaining | Wrap classes in logical sequence |
| Inheritance | Mixin receives class and returns extended class |

## Mixin Categories

| Category | Mixins | Usage |
|----------|--------|-------|
| Layout | Width, Height, Align | Dimensioning and positioning |
| State | Disabled, Hidden | Component state control |
| Appearance | Color | Visual styling |
| Behavior | Headless, Reaval | Special functionalities |

## Mixin Selection

| Need | Recommended Mixin |
|------|-------------------|
| Responsive width control | Width |
| Responsive height control | Height |
| Disable interaction | Disabled |
| Hide component | Hidden |
| Remove rendering | Headless |
| Apply color theme | Color |
| Align content | Align |
| Auto-scroll on reveal | Reaval |

## Rules

| Rule | Description |
|------|-------------|
| Echo required | Echo must be in chain for events to work |
| Order matters | Application follows right-to-left order |
| Private fields | Mixins use private fields for internal state |
| Getters/Setters | Properties exposed via getter/setter |
| AttributeChanged | Sync with HTML attributes |
| Internals | Mixins can use Custom Element internals |

## Common Combinations

| Component Type | Suggested Combination |
|----------------|----------------------|
| Interactive button | Disabled, Width, Hidden, Echo |
| Styled text | Color, Align, Hidden, Echo |
| Layout container | Width, Height, Hidden, Echo |
| Invisible component | Headless, Echo |
| Responsive card | Width, Hidden, Echo |

## Mixin Characteristics

| Characteristic | Description |
|----------------|-------------|
| Non-invasive | Don't modify existing behavior |
| Composable | Can be freely combined |
| Isolated | Each mixin has single responsibility |
| Reactive | Respond to attribute changes |
| Testable | Can be tested in isolation |

## Examples

```typescript
// ❌ Bad — inheritance for reuse (coupling)
class LoggingBase {
  log(msg: string) { console.log(msg) }
}
class ValidationBase extends LoggingBase {
  validate(v: unknown) { /* ... */ }
}
class UserComponent extends ValidationBase { /* inherits everything */ }

// ✅ Good — Mixin for composition without inheritance
const WithLogging = (Base: typeof HTMLElement) => class extends Base {
  log(msg: string) { console.log(`[${this.tagName}]`, msg) }
}
const WithValidation = (Base: typeof HTMLElement) => class extends Base {
  validate(v: unknown) { return v !== null && v !== undefined }
}

class UserComponent extends WithValidation(WithLogging(HTMLElement)) {
  // composes only what it needs
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Mixin without Echo in chain | Echo is required for event system to work |
| Incorrect application order | Order matters, remember it applies right-to-left |
| Mixin with multiple responsibilities | Each mixin should have single responsibility (rule 010) |
| Duplicate mixin logic | Use existing mixins instead of recreating behavior (rule 021) |
| Mixins with coupling | Mixins should be independent and composable |

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each mixin has single responsibility
- [016 - Common Closure Principle](../../rules/016_principio-fechamento-comum.md): related behaviors encapsulated together
- [021 - Prohibition of Logic Duplication](../../rules/021_proibicao-duplicacao-logica.md): mixins eliminate behavior duplication
