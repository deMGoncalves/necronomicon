---
name: constructor
description: Convention for constructor structure in Web Components. Use when creating custom Web Components, when implementing Custom Element constructors, or when reviewing code that violates constructor initialization sequence.
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Constructor

Convention for constructor structure in Web Components.

---

## When to Use

Use when creating or modifying constructors of custom components.

## Principle

| Principle | Description |
|-----------|-----------|
| Initialization | Constructor sets up only basic component structure |
| Simplicity | Minimal logic in constructor, only essential setup |

## Basic Rules

| Rule | Description |
|-------|-----------|
| Super first | Always call super() as first line |
| Shadow DOM | Create Shadow DOM if component has visualization |
| No complex logic | Avoid calculations or heavy operations |
| No DOM access | Don't access attributes or external DOM |
| Synchronous | Constructor must always be synchronous |

## Constructor Types

### Visual Component

| Aspect | Configuration |
|---------|--------------|
| Super | Mandatory call |
| Shadow DOM | Create with attachShadow |
| Mode | Always open |
| DelegatesFocus | true for interactive components |

### Headless Component

| Aspect | Configuration |
|---------|--------------|
| Constructor | Do not define (omit) |
| Mixin | Use Headless |
| Shadow DOM | Do not create |
| Purpose | Behavior/logic components |

## DelegatesFocus

| Use true | Use false/omit |
|-----------|-------------------|
| Components with focusable elements | Visual-only components |
| Buttons and links | Icons and images |
| Inputs and forms | Passive containers |
| Interactive labels and text | Decorations |
| Interactive containers | Separators |

## Execution Sequence

| Order | Action | Mandatory |
|-------|------|-------------|
| 1 | Call super() | Yes |
| 2 | Create Shadow DOM | If visual |
| 3 | Minimal synchronous operations | Optional |

## Examples

```typescript
// ❌ Bad — initialization out of order
class MyButton extends HTMLElement {
  constructor() {
    this.attachShadow({ mode: 'open' })  // error: super() not called
    super()
    this.render()
  }
}

// ✅ Good — correct sequence
class MyButton extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
    this.render()
  }
}
```

## Prohibitions

| What to avoid | Reason |
|--------------|-------|
| Accessing attributes in constructor | Attributes not yet processed by attributeChanged |
| Modifying external DOM | Component not yet connected to DOM |
| Asynchronous operations | Constructor must be synchronous (rule 022) |
| Adding event listeners | Use connected callback to ensure component is in DOM |
| Business logic | Belongs in methods, constructor only initializes structure (rule 010) |
| API calls | Use connected callback or specific methods |
| Constructor with more than 15 lines | Violates rule 007, simplify initialization |

## Shadow DOM Options

| Option | Values | Usage |
|-------|---------|-----|
| mode | open | Always use open for accessibility |
| delegatesFocus | true/false | true for interactive components |

## Component Categories

| Category | Shadow DOM | DelegatesFocus | Example |
|-----------|------------|----------------|---------|
| Interactive | Yes | Yes | Button, Link, Label |
| Container | Yes | Yes | Card, Container |
| Visual | Yes | No | Icon |
| Behavioral | No | N/A | On, Redirect |

## Internals API

Components that need Custom Element Internals (states, form association) should use lazy getter:

```javascript
get internals() {
  return this.#internals ??= this.attachInternals()
}
```

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): constructor has single responsibility of initializing basic component structure
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): simple and predictable constructor, without complex logic
- [007 - Line Restriction in Classes](../../rules/007_restricao-linhas-classes.md): constructor should have maximum of 15 lines
