# Clever Code

**Severity:** 🟡 Medium
**Associated Rule:** Rule 062

## What It Is

Code written to demonstrate the author's skill, not to communicate intent. Uses language tricks, dense expressions, operator abuse, or metaprogramming where direct and readable code would work equally well.

## Symptoms

- One-liners that do 5 things at once
- Operator abuse: `!!value`, `~~n`, `value | 0`, bitwise tricks
- Long chains of nested `reduce`, `flatMap`, and `map`
- Single-letter variables outside mathematical contexts
- Comment `// don't touch this` without explanation of why
- Code review comments asking "what does this do?" or "can this be clearer?"

## ❌ Example (violation)

```javascript
// ❌ "Clever" — what does this do?
const getDiscount = (u) =>
  u?.premium && u?.purchases > 10 ? (u?.vip ? 0.3 : 0.2) : u?.purchases > 5 ? 0.1 : 0;

// ❌ Bitwise trick to truncate number
const n = value | 0;

// ❌ Implicit coercion as logic
const display = user.name || user.email || user.id + '';
```

## ✅ Refactoring

```javascript
// ✅ Readable — clear intent in each line
function getDiscount(user) {
  if (!user) return 0;
  if (user.premium && user.vip && user.purchases > 10) return 0.3;
  if (user.premium && user.purchases > 10) return 0.2;
  if (user.purchases > 5) return 0.1;
  return 0;
}

// ✅ Explicit intent
const n = Math.trunc(value);
const display = user.name ?? user.email ?? String(user.id);
```

## Suggested Codetag

```typescript
// FIXME: Clever Code — unreadable nested ternaries
// TODO: Rewrite with if/else for clarity
```
