# Lava Flow (Dead Code / Zombie Code)

**Severity:** 🟠 High
**Associated Rule:** Rule 056

## What It Is

Code that is no longer used but remains in the system because no one is sure if it can be safely removed. Like lava that solidifies and hardens, this code becomes a permanent obstacle to maintenance. Abandoned, commented or never-called code.

## Symptoms

- Functions, classes or modules never called/executed
- Commented code with markers (`// old version`, `// deprecated`, `// TODO remove`)
- Imports of modules/packages that are never referenced
- `if` or `switch` branches that are never executed (test coverage = 0%)
- Variables declared and never read
- Entire files that no one knows what they're for

## ❌ Example (violation)

```javascript
// ❌ Functions no one calls, accumulated commented code
function calculateOldDiscount(price) { // deprecated - use calculateDiscount
  return price * 0.1;
}

// function formatUserV1(user) {
//   return user.name + ' (' + user.email + ')';
// }

function getUser(id) {
  // const cache = loadCache(); // removed in 2023 but kept for safety
  return db.find(id);
}
```

## ✅ Refactoring

```javascript
// ✅ Only what is used exists in code
function getUser(id) {
  return db.find(id);
}

// Dead code eliminated — version control keeps history
```

## Suggested Codetag

```typescript
// FIXME: Lava Flow — calculateOldDiscount never called, accumulated commented code
// TODO: Remove dead code; git keeps history
```
