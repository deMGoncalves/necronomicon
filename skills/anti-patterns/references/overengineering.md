# Overengineering

**Severity:** 🟡 Medium
**Associated Rule:** Rule 064

## What It Is

Designing or implementing a solution much more complex than the problem requires. Adding abstractions, layers, design patterns, plugin systems, or configurability before there's evidence of real need.

## Symptoms

- Introducing pattern without clear problem being solved (e.g., Strategy pattern without algorithm variation)
- Interfaces with a single implementer "to facilitate future testing"
- Configuration systems for something that will never change
- 5-layer abstractions for a CRUD operation
- Design Patterns applied where direct code would work
- "I made it generic to reuse later"

## ❌ Example (violation)

```javascript
// ❌ Plugin system to save a user in database
class UserRepository {
  constructor(storageStrategy) { this.strategy = storageStrategy; }
  save(user) { return this.strategy.persist(user); }
}

class DatabaseStorageStrategy {
  constructor(adapterFactory) { this.adapter = adapterFactory.create(); }
  persist(user) { return this.adapter.execute('INSERT', user); }
}

// There never was another storage. There never will be.
```

## ✅ Refactoring

```javascript
// ✅ Straight to the point — refactor when need is real (YAGNI + KISS)
async function saveUser(user) {
  return db.users.create(user);
}

// Only add abstraction when there are REAL multiple storages
```

## Suggested Codetag

```typescript
// FIXME: Overengineering — 4 layers of abstraction for simple db.create()
// TODO: Simplify: use db.users.create() directly until 2nd storage exists
```
