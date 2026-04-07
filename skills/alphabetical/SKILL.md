---
name: alphabetical
description: Convention for organizing properties in objects/JSON — when creating or modifying JavaScript/JSON/TypeScript objects — when ordering properties, imports, exports, or any list of attributes
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Alphabetical

Convention for organizing properties in objects and JSON.

---

## When to Use

Use when creating or modifying objects to order properties alphabetically.

## Principle

| Principle | Description |
|-----------|-----------|
| Predictability | Alphabetical order reduces cognitive cost of locating items |

## Rules

| Rule | Description |
|-------|-----------|
| Alphabetical order | Properties must be in alphabetical order (A-Z) |
| Recursive | Nested objects also follow alphabetical order |
| Case-sensitive | Lowercase letters after uppercase (`A` before `a`) |

## Application

| Context | Description |
|----------|-----------|
| Object literals | Properties of inline objects |
| JSON files | Keys in configuration files |
| Module exports | Named exports in index |
| Configurations | Configuration objects |
| CSS-in-JS | CSS properties in template literals or objects |
| TypeScript interfaces | Properties of types and interfaces |
| Class properties | Private or public fields and properties |
| Style objects | Style properties in JavaScript objects |

## Exceptions

Do not apply alphabetical order when:

| Situation | Justification |
|----------|---------------|
| Critical logical order | Sequence has semantic meaning (ex: coordinates x, y, z) |
| Semantic grouping | Related properties should stay together |
| Ordered arrays | Order has functional meaning |
| Constructors | Parameters follow order of importance |
| External APIs | Structure defined by external contract |

## Examples

```typescript
// ❌ Bad — properties in random order
const config = {
  timeout: 3000,
  apiUrl: 'https://api.example.com',
  debug: false,
  maxRetries: 3,
}

// ✅ Good — properties in alphabetical order
const config = {
  apiUrl: 'https://api.example.com',
  debug: false,
  maxRetries: 3,
  timeout: 3000,
}
```

## Prohibitions

| What to avoid | Reason |
|--------------|-------|
| Ordering properties with logical dependency | When order has semantic meaning, maintain it (coordinates, sequences) |
| Force alphabetical order in external APIs | Respect contract of third-party APIs |
| Break cohesive groupings | Strongly related properties should stay together (rule 016) |

## Rationale

- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): alphabetical order is predictable and reduces cognitive cost when searching for properties, eliminating need to understand ordering logic
- [006 - Prohibition of Abbreviated Names](../../rules/006_proibicao-nomes-abreviados.md): complete descriptive names are easier to locate when alphabetically sorted
- [016 - Common Closure Principle](../../rules/016_principio-fechamento-comum.md): properties that change together should stay grouped, but within the group apply alphabetical order
