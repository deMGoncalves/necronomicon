---
name: dataflow
description: Convention for component communication via event bus — when creating reactive data flows between decoupled components, implementing event bus communication, or reviewing code that uses direct references between components
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Dataflow

Convention for component communication via event bus with declarative transformations.

---

## When to Use

Use when creating reactive communication between components without direct coupling, enabling declarative data flow and transformations.

## Principle

| Principle | Description |
|-----------|-------------|
| Decoupling | Components don't know each other directly |
| Reactivity | Changes propagate automatically via events |
| Declarative | Connections defined in template, not imperative code |
| Composition | Transformations composed via filter pipeline |

## Syntax

```
source/event:type/sink|filter1=value1|filter2=value2
```

| Part | Required | Description |
|------|----------|-------------|
| source | Yes | Identifier of emitter component |
| event | Yes | Custom event name |
| type | Yes | Action type on receiver component |
| sink | Yes | Method, attribute, or setter name |
| filters | No | Transformations applied to payload |

## Source (Emitter)

| Type | Syntax | Description | Usage |
|------|--------|-------------|-------|
| Wildcard | * | Any component | Listen to all events of that type |
| ID | #elementId | Specific component by ID | Listen to single component identified by id |
| Name | elementName | Specific component by name | Listen to component identified by name attribute |
| Node | element-tag | All components of a type | Listen to all elements of that custom element |

## Event

| Aspect | Description |
|--------|-------------|
| Name | Name of custom event dispatched by emitter |
| Format | Lowercase with hyphens or underscores |
| Convention | Past tense verbs indicating completed action |
| Examples | sent, clicked, changed, thinking, responded |

## Type (Action Type)

| Type | Description | Effect |
|------|-------------|--------|
| method | Calls method on receiver | `this[sink](payload)` |
| attribute | Sets HTML attribute on receiver | `this.setAttribute(sink, payload)` |
| setter | Sets property via setter on receiver | `this[sink] = payload` |

## Sink (Receiver)

| Type | Description |
|------|-------------|
| Public method | Name of method to be called |
| HTML attribute | Name of attribute to be set |
| Setter | Name of property with setter |
| Nomenclature | Must exist on receiver component |

## Filters (Sparks)

| Filter | Parameters | Function | Usage |
|--------|------------|----------|-------|
| always | value | Ignores token, returns fixed value | Set constant value |
| prop | path | Extracts object property | Access nested property |
| inc | - | Increments number by 1 | Counter, index |
| dec | - | Decrements number by 1 | Countdown counter |
| add | value | Adds value to number | Arithmetic operations |
| subtract | value | Subtracts value from number | Arithmetic operations |
| equals | value | Checks equality | Comparisons |
| different | value | Checks difference | Comparisons |
| gt | value | Greater than | Comparisons |
| gte | value | Greater or equal | Comparisons |
| lt | value | Less than | Comparisons |
| lte | value | Less or equal | Comparisons |
| truthy | - | Converts to boolean | Validations |
| not | - | Inverts boolean | Logical negation |
| len | - | Returns length | Array or string size |

## morph-on Component

| Aspect | Description |
|--------|-------------|
| Tag | `<morph-on>` |
| Purpose | Connect dataflow to parent component |
| Type | Headless component (no visualization) |
| Attribute | `value` contains dataflow string |
| Location | Child of component that will receive events |
| Lifecycle | Connects to parent on connected callback |

## Filter Pipeline

| Aspect | Description |
|--------|-------------|
| Syntax | Separated by pipe `|` |
| Order | Execute from left to right |
| Composition | Output of one is input of next |
| Transformation | Each filter transforms the payload |
| Format | `filter=parameter` |

## Event Bus

| Aspect | Description |
|--------|-------------|
| Global target | Centralized target object for events |
| Propagation | Events propagate through bus, not DOM |
| Detail | Contains attribute (id, name), node, token |
| Matching | Regex checks if source matches emitter |
| AbortController | Manages listener lifecycle |

## Echo Mixin

| Aspect | Description |
|--------|-------------|
| Purpose | Adds dataflow capability to component |
| Application | Used in mixin composition |
| on attribute | Observes on attribute for dynamic connections |
| Dispatch | Overrides dispatchEvent to send to bus |
| Controllers | Manages AbortControllers for cleanup |

## Usage Examples

| Scenario | Dataflow |
|----------|----------|
| Call ask method with data | `input/sent:method/ask` |
| Set waiting attribute as true | `agent/thinking:attribute/waiting\|always=true` |
| Set waiting attribute as false | `agent/responded:attribute/waiting\|always=false` |
| Add item to list | `form/submitted:method/push` |
| Extract property and call method | `api/loaded:method/render\|prop=data.users` |
| Navigate on click | `button/click:method/go` |

## Organization Patterns

| Pattern | Description |
|---------|-------------|
| Colocation | Define morph-on next to receiver component |
| Grouping | Group related dataflows |
| Comments | Document purpose of dataflows |
| Nomenclature | Use name on components for clear identification |

## Lifecycle

| Phase | Action |
|-------|--------|
| Connected | morph-on waits for parent to be defined |
| Connected | Calls connectArc on parent |
| Connected | Creates AbortController and registers listener |
| Event dispatch | Emitter fires event on bus |
| Event match | Receiver checks if source corresponds |
| Transform | Applies filters to payload |
| Execute | Calls method, sets attribute or setter |
| Disconnected | Aborts all controllers |

## Examples

```typescript
// ❌ Bad — direct coupling between components
class CartComponent {
  updateTotal() {
    const header = document.querySelector('app-header')
    header.cartCount = this.items.length  // direct coupling
  }
}

// ✅ Good — communication via event (dataflow)
class CartComponent {
  updateTotal() {
    this.dispatchEvent(new CustomEvent('cart:updated', {
      detail: { count: this.items.length },
      bubbles: true, composed: true,
    }))
  }
}
// app-header listens to event without knowing cart
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Dataflow between coupled components | Use direct method if there's dependency (rule 013) |
| Complex logic in filters | Filters should be simple and pure transformations (rule 022) |
| Creating custom filters unnecessarily | Use built-in filters when possible, avoid complexity |
| Multiple dataflows with same origin and destination | Consolidate into single dataflow with composed filters |
| Circular dataflows | Creates infinite event loops, invalid design |
| Using on attribute directly | Prefer morph-on component for declarativeness |
| Filters with side effects | Filters should be pure functions (rule 010) |

## Best Practices

| Practice | Description |
|----------|-------------|
| Explicit name | Use name attribute for semantic identification |
| Composed filters | Compose complex transformations with pipeline |
| Documentation | Comment purpose of each dataflow |
| Grouping | Group dataflows by functional context |
| Flow testing | Validate that events propagate correctly |
| Cleanup | Trust disconnected to clean up listeners |

## Creating Custom Filters

| Aspect | Description |
|--------|-------------|
| Function | Receives token and value, returns transformation |
| Registration | `spark.set(name, fn)` |
| Pure | Function must be pure without side effects |
| Naming | Descriptive and concise name |
| Parameters | First is payload, second is filter value |

## Debugging

| Technique | Description |
|-----------|-------------|
| Console log in dispatchEvent | Verify events being dispatched |
| Inspect bus target | Verify registered listeners |
| Validate source regex | Test identifier matching |
| Verify name and id | Ensure components have identification |
| Test filters in isolation | Validate transformations individually |

## Rationale

- [013 - Interface Segregation Principle](../../rules/013_principio-segregacao-interfaces.md): components communicate via event contracts, not direct interfaces
- [016 - Common Closure Principle](../../rules/016_principio-fechamento-comum.md): dataflows grouped by functional context
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): clear declarative syntax and simple filter composition
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each filter has unique and specific transformation
