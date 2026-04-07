# Accidental Mutation

**Severity:** 🟠 High
**Associated Rule:** Rule 052

## What It Is

A function receives an object or array as parameter and modifies it directly, without the caller expecting or wanting this change. The side effect is invisible in the function signature — the name suggests a read or transformation operation, but the original state is silently altered.

## Symptoms

- Function named as `getX`, `filterX` or `calculateX` that also modifies the parameter
- Bugs that appear only after calling a specific function
- Arrays that change order unexpectedly (`Array.sort` operates in-place)
- Objects with properties changed without the calling module explicitly doing so
- Tests dependent on execution order

## ❌ Example (violation)

```javascript
// ❌ .sort() operates in-place — modifies original array
function getTopUsers(users) {
  return users
    .sort((a, b) => b.score - a.score) // MUTATES users!
    .slice(0, 5);
}

const users = [{ name: 'Alice', score: 80 }, { name: 'Bob', score: 95 }];
const top = getTopUsers(users);
console.log(users); // [Bob, Alice] — original order destroyed
```

## ✅ Refactoring

```javascript
// ✅ Shallow copy with spread — preserves original array
function getTopUsers(users) {
  return [...users]
    .sort((a, b) => b.score - a.score)
    .slice(0, 5);
}

// ✅ For objects: return new object
function deactivate(user) {
  return { ...user, active: false };
}

// ✅ For deep clone: structuredClone (Node 17+)
const copy = structuredClone(order);
```

## Suggested Codetag

```typescript
// FIXME: Accidental Mutation — getTopUsers modifies original array via .sort()
// TODO: Clone users before sorting: [...users].sort(...)
```
