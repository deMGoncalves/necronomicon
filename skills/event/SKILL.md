---
name: event
description: Convention for using DOM events and custom events — when creating event handlers, dispatching custom events, or communicating between components via DOM events
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Event

Convention for using DOM events and custom events for interactivity and component communication.

---

## When to Use

Use when creating event handlers that respond to user interactions or when components need to communicate state changes.

## Principle

| Principle | Description |
|-----------|-------------|
| Decoupled communication | Components communicate via events without direct dependency |
| Reactivity | Components react to changes through listeners |

## Event Decorator

| Aspect | Description |
|--------|-------------|
| Syntax | `@on.{eventType}` |
| Common types | click, submit, input, keydown, change |
| Selector | Optional first parameter to filter target element |
| Modifiers | Additional parameters to alter event behavior |
| Target method | Decorated method receives event or transformed data |

## Decorator Structure

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| Selector | String | No | CSS selector to filter target element within Shadow DOM |
| Modifiers | Function | No | Functions that modify event before passing to handler |

## Available Modifiers

| Modifier | Function | Usage |
|----------|----------|-------|
| prevent | Prevents default behavior | Avoid form submit, link navigation |
| stop | Stops event propagation | Prevent event from bubbling up DOM tree |
| enter | Filters only Enter key | Execute action on Enter press |
| formData | Extracts form data | Transforms FormData into object |
| value | Extracts target value | Pass only element value |
| detail | Extracts CustomEvent detail | Access custom event data |

## Application Order

| Order | Element |
|-------|---------|
| 1 | Event type |
| 2 | Selector (optional) |
| 3 | Modifiers (optional, multiple allowed) |

## Custom Events

| Aspect | Description |
|--------|-------------|
| Creation | Use customEvent function from @event package |
| Type | String identifying the event |
| Detail | Data associated with event |
| Bubbles | Always true to allow propagation |
| Cancelable | Always true to allow prevention |

## Event Dispatch

| Aspect | Description |
|--------|-------------|
| Method | `this.dispatchEvent()` |
| Context | Called on component that emits event |
| Propagation | Event bubbles up DOM tree until captured |
| Timing | Dispatch is synchronous, handlers execute immediately |

## Event Types

| Category | Events | Usage |
|----------|--------|-------|
| Mouse | click, dblclick, mousedown, mouseup | Mouse interactions |
| Keyboard | keydown, keyup, keypress | Keyboard interactions |
| Form | submit, change, input, reset | Form manipulation |
| Focus | focus, blur, focusin, focusout | Focus management |
| Custom | Custom names | Component communication |

## Custom Event Naming

| Rule | Description |
|------|-------------|
| Lowercase | Use only lowercase letters |
| Descriptive | Name should describe what happened |
| Past tense verbs | Indicates completed action (sent, clicked, changed) |
| Namespace | Use prefix for domain-specific events |

## Event Handlers

| Aspect | Description |
|--------|-------------|
| Return | Return this to maintain fluent interface |
| Async | Can be async if necessary |
| Parameter | Receives event or data transformed by modifier |
| Name | Use Symbol via bracket notation for encapsulation |

## Examples

```typescript
// ❌ Bad — ad-hoc event without typing or bubbling
element.dispatchEvent(new Event('change'))

// ✅ Good — custom event with detail, bubbles and composed
element.dispatchEvent(new CustomEvent('user:updated', {
  detail: { userId: '123', name: 'Alice' },
  bubbles: true,
  composed: true,
}))
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Event listeners in constructor | Constructor should not access DOM (rule constructor) |
| Direct external DOM manipulation | Violates Shadow DOM encapsulation |
| Complex logic in handler | Extract to helper methods (rule 010) |
| Non-explicit side effects | Handler should have clear responsibility |
| Modifying original event | Modifiers should return new value, not mutate |
| Multiple responsibilities | One handler per action (rule 010) |

## Selectors

| Type | Description |
|------|-------------|
| Tag | HTML element name |
| Class | CSS class selector |
| ID | ID selector |
| Attribute | Attribute selector |
| Wildcard | Asterisk for any element |

## Best Practices

| Practice | Description |
|----------|-------------|
| Use Symbol for handlers | Encapsulate event methods with bracket notation |
| Combine decorators | Stack multiple decorators when necessary |
| Modifiers first | Apply modifiers before business logic |
| Named events | Create constants/enum for custom event names |
| Structured detail | Use objects with named properties in detail |

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each handler has single responsibility, don't mix multiple actions in one handler
- [013 - Interface Segregation Principle](../../rules/013_principio-segregacao-interfaces.md): events allow communication without direct coupling, components interact via event contracts
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): simple handlers and composable modifiers keep code predictable
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): event handlers should have maximum 15 lines
