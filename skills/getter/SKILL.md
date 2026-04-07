---
name: getter
description: Convention for using getters for reading value treatment. Use when creating getters that need to transform, validate or format data before exposing — when reviewing getters that return raw values without logic.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Getter

Convention for using getters for reading value treatment associated with private members.

---

## When to Use

Use when creating getters that need to treat value reading, always associated with private members.

## Purpose

| Responsibility | Description |
|----------------|-------------|
| Default value | Assign default value when private member is null or undefined |
| Transformation | Apply transformation or formatting to read value |
| Lazy initialization | Create instance only when first accessed |
| Read validation | Return alternative value based on conditions |

## Implementation Patterns

| Pattern | Usage |
|---------|-------|
| Null coalescing | Assign default value using `??=` operator |
| Direct return | Return value without transformation when no default |
| Conditional transformation | Apply transformation based on value condition |
| Lazy initialization | Create complex instance only on first access |

## Relation with Private Members

| Rule | Description |
|------|-------------|
| Always private | Getter must access private member (prefix `#`) |
| Never public | Getter should not read public property |
| One to one | Each getter accesses single private member |
| Corresponding name | Getter name corresponds to private member name |

## Examples

```typescript
// ❌ Bad — trivial getter without logic (should be property)
get name() { return this.#name }  // just returns, no transformation

// ✅ Good — getter with transformation logic
get displayName() {
  return this.#name?.trim().toLowerCase() ?? 'anonymous'
}

get isValid() {
  return this.#email.includes('@') && this.#name.length > 0
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Pure getter without logic | Violates rule 008: getter must have treatment logic, not be mere accessor |
| Complex logic | Getters should have simple and predictable logic |
| Side effects | Getter should not modify state or trigger actions |
| Expensive operations | Avoid heavy operations that make reading slow |
| Multiple member access | Getter should focus on single private member (rule 010) |

## Best Practices

| Practice | Description |
|----------|-------------|
| Null coalescing | Use `??=` to assign default value concisely |
| Direct return | Return value without transformation when no additional logic |
| Lazy initialization | Create complex instances only on first access |
| Getter with setter | Always have corresponding setter for same private member |

## Rationale

- [008 - Prohibition of Pure Getters/Setters](../../rules/008_proibicao-getters-setters.md): getters are allowed when they have treatment logic (default value, transformation, lazy initialization), prohibited when they are mere direct accessors without logic
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): treatment logic centralized in getter keeps code predictable and easy to maintain
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): getter has single responsibility of treating corresponding private member reading
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): getter should have maximum 15 lines, extract complex logic to methods
