# Refused Bequest

**Severity:** 🟡 Medium
**Associated Rule:** Rule 059

## What It Is

Subclass that inherits methods and data from parent class but doesn't use or doesn't want part of them. The subclass "refuses" the inheritance, indicating the inheritance hierarchy is wrong or should use composition instead of inheritance.

## Symptoms

- Subclass overrides parent methods to throw `throw new Error('Not supported')`
- Inherited methods that are never called in the subclass (60%+ unused)
- Need to check `instanceof` to know what the object supports
- Subclass that inherits to "reuse code" but not because it's the same type
- Empty implementations (`pass`) or stubs for inherited methods that don't make sense

## ❌ Example (violation)

```javascript
// ❌ ReadOnlyList inherits from List but refuses write methods
class List {
  add(item) { this.items.push(item); }
  remove(item) { ... }
  get(index) { return this.items[index]; }
}

class ReadOnlyList extends List {
  add() { throw new Error('Read-only list!'); }    // refuses inheritance
  remove() { throw new Error('Read-only list!'); } // refuses inheritance
}
```

## ✅ Refactoring

```javascript
// ✅ Composition: ReadOnlyList doesn't inherit, uses
class ReadOnlyList {
  #items;
  constructor(items) { this.#items = [...items]; }
  get(index) { return this.#items[index]; }
  get length() { return this.#items.length; }
}

// If you need common behavior: extract to helper/mixin
const listBehavior = { iterate() { ... }, map() { ... } };
```

## Suggested Codetag

```typescript
// FIXME: Refused Bequest — ReadOnlyList inherits from List but refuses add/remove
// TODO: Replace Inheritance with Composition — create independent ReadOnlyList
```
