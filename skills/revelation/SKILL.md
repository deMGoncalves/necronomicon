---
name: revelation
description: Convention for module index structure — when creating or organizing a module's index file — when defining which symbols are public vs internal and structuring re-exports
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Revelation

Convention for module index structure (Module Revelation Pattern).

---

## When to Use

Use when creating or organizing module exports.

## Principle

| Principle | Description |
|-----------|-------------|
| Single Entry Point | Index.js is the only public interface of the module |
| Simplicity | Only re-exports, no additional logic |

## Rules

| Rule | Description |
|------|-------------|
| Only re-exports | Index contains only imports and direct re-exports |
| No logic | Code beyond import/export is prohibited |
| No variables | Declaring intermediate variables is prohibited |

## Structure

| Syntax | Usage |
|--------|-------|
| `import 'path'` | Side-effect import |
| `export { default } from 'path'` | Re-export default as default |
| `export { default as Name } from 'path'` | Re-export default with name |

## Example

```javascript
// packages/book/button/index.js
export { default } from './button.js'
```

```javascript
// packages/book/index.js
export { default as Button } from './button/index.js'
export { default as Text } from './text/index.js'
export { default as Icon } from './icon/index.js'
```

## Examples

```typescript
// ❌ Bad — exposes everything without control
export * from './UserService'
export * from './UserRepository'
export * from './UserValidator'
export * from './internal/UserHelpers'  // leaks internal implementation

// ✅ Good — Revelation Pattern — exposes only public interface
export { UserService } from './UserService'
export type { User, CreateUserDTO } from './types'
// UserRepository, UserHelpers are implementation details — not exported
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Logic in index.js | Index should have only re-exports (rule 010) |
| Intermediate variables | Declaring variables is prohibited, only direct import/export |
| Transformations in index | Transformation logic belongs to modules, not index |
| Index without exports | Every module should expose clear interface |

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): index has single responsibility of exposing module's public interface, without additional logic
- [015 - Release Reuse Equivalency Principle](../../rules/015_principio-equivalencia-lancamento-reuso.md): cohesive module with clear interface facilitates reuse in other contexts
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): simple and direct index is easier to understand and maintain
