---
name: enum
description: Convention for creating enums eliminating magic strings/numbers — when identifying repeated strings or numbers more than once, creating domain constants, or reviewing code with hardcoded literals in conditionals
model: haiku
allowed-tools: Write, Read, Edit, Glob, Grep
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Enum

Convention for creating enums eliminating magic strings/numbers.

---

## When to Use

Use when identifying literal values (strings or numbers) repeated more than 1x.

## Conditions

| Condition | Action |
|-----------|--------|
| Value repeats 2+ times in same module | Create local enum |
| Value used by multiple modules | Create enum in owner module and export |

## Nomenclature

| Type | File | Enum | Keys |
|------|------|------|------|
| DOM selectors | `element.js` | `Element` | `UPPER_SNAKE_CASE` |
| CSS properties | `property.js` | `Property` | `UPPER_SNAKE_CASE` |
| Events | `event.js` | `Event` | `UPPER_SNAKE_CASE` |
| Status/States | `status.js` | `Status` | `UPPER_SNAKE_CASE` |
| Types/Roles | `type.js` | `Type` | `UPPER_SNAKE_CASE` |
| Attributes | `attribute.js` | `Attribute` | `UPPER_SNAKE_CASE` |

## Rule

| Principle | Description |
|-----------|-------------|
| Ownership | Module that defines the concept owns the enum |

## Enum Structure

```javascript
export const Status = Object.freeze({
  PENDING: 'pending',
  ACTIVE: 'active',
  COMPLETED: 'completed',
})
```

## Examples

```typescript
// ❌ Bad — magic strings and numbers
if (order.status === 'pending') { /* ... */ }
if (user.role === 'admin') { /* ... */ }
const timeout = 3000  // what does this number mean?

// ✅ Good — enums eliminate ambiguity
enum OrderStatus { Pending = 'pending', Active = 'active', Cancelled = 'cancelled' }
enum UserRole { Admin = 'admin', Editor = 'editor', Viewer = 'viewer' }
const REQUEST_TIMEOUT_MS = 3000

if (order.status === OrderStatus.Pending) { /* ... */ }
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Repeated literal values | Create enum when value appears 2+ times (rule 024) |
| Enum without Object.freeze | Violates rule 029, enum must be immutable |
| Enum with non-descriptive values | Use values that reveal intention (rule 006) |
| Magic numbers or magic strings | Replace with named enum (rule 024) |
| Enum in wrong file | Owner module of concept defines the enum |

## Rationale

- [024 - Prohibition of Magic Constants](../../rules/024_proibicao-constantes-magicas.md): literal values should be named constants for traceability and maintenance
- [029 - Object Immutability](../../rules/029_imutabilidade-objetos-freeze.md): enums should be frozen with Object.freeze() to prevent accidental runtime modifications
- [021 - Prohibition of Logic Duplication](../../rules/021_proibicao-duplicacao-logica.md): values should not be duplicated, centralize in enum
