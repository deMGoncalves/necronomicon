# Speculative Generality

**Severity:** 🟡 Medium
**Associated Rule:** Rule 023

## What It Is

Code created to support hypothetical use cases that "might" be needed in the future: hooks, parameters, abstract classes, and configurations that have no current use. Fowler: *"Oh, I think we'll need the ability to do this kind of thing someday."*

## Symptoms

- Empty classes or methods that aim to be placeholders for future functionality
- Function parameters that always receive the same value and never vary
- Abstract classes with a single implementer
- Hooks and callbacks never invoked ("for future extensibility")
- Public methods that no external code calls
- Inheritance created "for when we have more types"
- Code with more than 5% of lines marked as disabled or with `// TODO: future implementation`

## ❌ Example (violation)

```javascript
// ❌ "options" parameter never used with different values
function getUser(id, options = { includeDeleted: false, format: 'full' }) {
  // options.includeDeleted is never true in any caller
  // options.format is never different from 'full'
  return db.users.find(id);
}

// ❌ Abstract class with single implementer
class BaseNotifier { notify(message) { throw new Error('Not implemented'); } }
class EmailNotifier extends BaseNotifier { notify(message) { sendEmail(message); } }
// EmailNotifier is the only implementer that will exist for the next 2 years
```

## ✅ Refactoring

```javascript
// ✅ Simple and direct — add flexibility when there's a real use case (YAGNI)
function getUser(id) {
  return db.users.find(id);
}

function sendNotification(message) {
  sendEmail(message);
}

// When there's a real SMSNotifier, then create abstraction
```

## Suggested Codetag

```typescript
// FIXME: Speculative Generality — options never used, BaseNotifier has 1 impl
// TODO: Remove abstraction until 2nd REAL implementer exists
```
