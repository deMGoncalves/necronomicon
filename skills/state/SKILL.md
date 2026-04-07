---
name: state
description: Convention for state control in Web Components using Element Internals API — when creating manageable states via internals.states in Web Components, implementing custom CSS states (:state()) or reviewing code that uses attributes to manage state
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# State

Convention for state control in Web Components using Element Internals API with Symbol contracts for custom state manipulation.

---

## When to Use

Use when creating states in Web Components that need to be manageable via HTML attributes, accessible via CSS pseudo-class state, and synced with Element Internals API.

## Purpose

| Responsibility | Description |
|----------------|-------------|
| Manageable state | Expose custom state via Element Internals API for use in CSS and JavaScript |
| Sync | Keep HTML attribute, JavaScript property and internals.states synced |
| Clear contract | Use Symbol to define state manipulation contract |
| Middleware | Intercept state changes via decorator to execute additional logic |

## State Anatomy

| Component | Function | Location |
|-----------|----------|----------|
| Private member | Store state value | Private field in class |
| Getter | Return state value with default | Corresponding public getter |
| Setter | Assign new value to state | Public setter with decorators |
| Contract Symbol | Define manipulation interface | interface.js file |
| Contract method | Manipulate internals.states | Method with bracket notation |
| internals getter | Create Element Internals | Getter with lazy initialization |

## Execution Flow

| Step | Action | Responsible |
|------|--------|-------------|
| 1 | HTML attribute changed or property set | Browser or JavaScript |
| 2 | attributeChanged decorator triggers | Decorator system |
| 3 | Setter executes and assigns value | Class setter |
| 4 | around decorator intercepts | Middleware |
| 5 | Contract method is called | Middleware via bracket notation |
| 6 | internals.states is updated | Contract method |
| 7 | CSS pseudo-class state reacts | Browser |

## Associated Decorators

| Decorator | Function |
|-----------|----------|
| attributeChanged | Syncs setter with HTML attribute change |
| around | Intercepts setter to execute contract method |

## Nomenclature

| Element | Pattern | Example |
|---------|---------|---------|
| State (attribute) | Past participle or adjective | active, collapsed, disabled, visible |
| Symbol (contract) | State + suffix `-able` | activable, collapsible, disableable, visibilable |
| Private member | Hashtag + state name | #active, #collapsed, #disabled |
| Getter | State name | active, collapsed, disabled |
| Setter | State name | active, collapsed, disabled |
| Contract method | Bracket notation with Symbol | [activable], [collapsible] |

## Relation with Internals

| Aspect | Description |
|--------|-------------|
| Lazy initialization | internals created only on first access for optimization |
| attachInternals | Called once in getter using null coalescing |
| states.add | Adds custom state when value is truthy |
| states.delete | Removes custom state when value is falsy |
| CSS access | State accessible via pseudo-class :state(name) |

## Relation with Symbol

| Aspect | Description |
|--------|-------------|
| Explicit contract | Symbol defines clear state manipulation interface |
| Correlated name | Symbol has -able suffix related to state name |
| Bracket notation | Method uses Symbol between brackets for private contract |
| Import | Symbol exported from interface.js and imported in class |

## Examples

```typescript
// ❌ Bad — state via attribute (exposed, no encapsulation)
class MyInput extends HTMLElement {
  setValid() {
    this.setAttribute('data-valid', '')  // state exposed in DOM
  }
}

// ✅ Good — state via Element Internals
class MyInput extends HTMLElement {
  #internals = this.attachInternals()

  setValid() {
    this.#internals.states.add('valid')  // encapsulated state
    // CSS: my-input:state(valid) { ... }
  }
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Use @retouch or @repaint | Doesn't re-render, states use @around(contract) for internals sync |
| Setter without contract | State doesn't sync with internals.states, making it inaccessible via CSS |
| Name without correlation | Symbol should have -able suffix correlated to state name for clarity |
| Multiple states in method | Each contract method treats single state (rule 010) |
| Complex logic in method | Method only adds or removes state, no additional side effects |
| Manipulate internals.states in setter | Manipulation should be in contract method, not setter |

## Best Practices

| Practice | Description |
|----------|-------------|
| Symbol contract | Always create Symbol in interface.js for each manageable state |
| @around decorator | Use decorator to intercept setter and call contract method |
| Ternary operator | Use ternary condition for clarity in add/delete logic |
| Return this | Always return this in contract method for fluent interface |
| Boolean default | States should have false default value in getter |
| Lazy internals | Create internals only on first access using null coalescing |

## Rationale

- [008 - Prohibition of Pure Getters/Setters](../../rules/008_proibicao-getters-setters.md): setter has treatment logic via @around middleware
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): clear and predictable pattern for state control
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): contract method treats single state
- [009 - Tell, Don't Ask](../../rules/009_diga-nao-pergunte.md): component manages own state internally
- [036 - Restriction of Functions with Side Effects](../../rules/036_restricao-funcoes-efeitos-colaterais.md): contract method only manipulates internals.states
