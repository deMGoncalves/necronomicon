---
name: setter
description: Convention for using setters for writing value treatment. Use when creating setters that need to validate input, sync internal state or trigger side effects — when reviewing setters that are simple assignments.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Setter

Convention for using setters for writing value treatment associated with private members.

---

## When to Use

Use when creating setters that need to treat value writing, always associated with private members.

## Purpose

| Responsibility | Description |
|----------------|-------------|
| Simple assignment | Assign value to corresponding private member |
| Attribute sync | Sync value with HTML attribute using decorator |
| Re-rendering trigger | Trigger partial or complete component re-rendering |
| Write validation | Apply transformation or normalization before assigning |

## Implementation Patterns

| Pattern | Usage |
|---------|-------|
| Direct assignment | Assign received value directly to private member |
| With re-rendering | Use decorator to trigger visual update after writing |
| With sync | Use decorator to keep HTML attribute synced |
| With transformation | Apply simple transformation before assignment |

## Associated Decorators

| Decorator | Function |
|-----------|----------|
| attributeChanged | Syncs setter with HTML attribute change |
| retouch | Triggers partial re-rendering after value change |
| repaint | Triggers complete re-rendering after value change |

## Relation with Private Members

| Rule | Description |
|------|-------------|
| Always private | Setter must modify private member (prefix `#`) |
| Never public | Setter should not modify public property |
| One to one | Each setter modifies single private member |
| Corresponding name | Setter name corresponds to private member name |

## Examples

```typescript
// ❌ Bad — trivial setter (violates rule 008)
set email(value: string) { this.#email = value }  // no validation

// ✅ Good — setter with validation and sync
set email(value: string) {
  if (!value.includes('@')) throw new InvalidEmailError(value)
  this.#email = value
  this.internals.states.add('email-validated')
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Pure setter without logic | Violates rule 008: setter must have treatment logic (sync, re-rendering, transformation), not be mere assignment |
| Complex business logic | Setters should have simple assignment and transformation logic |
| Unrelated side effects | Setter should not modify other states besides target member (rule 010) |
| Complex validation | Complex validations should be in business methods |
| Modify multiple members | Setter should focus on single private member (rule 010) |
| Async operations | Setters should be synchronous and predictable |

## Relation with Getter

| Aspect | Description |
|--------|-------------|
| Required pair | Setter should have corresponding getter for same member |
| Declaration order | Getter always before setter in class anatomy |
| Consistent type | Getter and setter of same member should have compatible types |

## Best Practices

| Practice | Description |
|----------|-------------|
| Simple assignment | Setter focuses on assigning value and triggering necessary side effects |
| Decorators | Use @attributeChanged, @retouch or @repaint for sync |
| Minimal transformation | Apply only simple and direct transformations |
| Setter with getter | Always have corresponding getter for same private member |

## Rationale

- [008 - Prohibition of Pure Getters/Setters](../../rules/008_proibicao-getters-setters.md): setters are allowed when they have treatment logic (attribute sync, re-rendering, transformation), prohibited when they are mere direct assignments without logic
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): treatment logic centralized in setter keeps code predictable and easy to maintain
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): setter has single responsibility of treating corresponding private member writing
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): setter should have maximum 15 lines, extract complex logic to methods
