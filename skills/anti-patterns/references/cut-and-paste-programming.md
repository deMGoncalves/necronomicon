# Cut-and-Paste Programming

**Severity:** 🔴 Critical
**Associated Rule:** Rule 021

## What It Is

Reusing code by copying and pasting blocks between files or functions instead of creating reusable abstractions. Logic exists in multiple places without a single source of truth. Direct violation of DRY (Don't Repeat Yourself).

## Symptoms

- Direct copying of code blocks with more than 5 lines between classes or methods is prohibited
- Complex logic used in more than 2 locations without extraction
- Identical or nearly identical code blocks in different files
- Bug fixed in one place but present in clones
- `// copied from UserService` as a comment
- Functions with names like `processOrderV2`, `processOrderFinal`, `processOrderFixed`

## ❌ Example (violation)

```javascript
// ❌ Same validation copied in three places
function createUser(data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Invalid email');
  if (!data.name || data.name.length < 2) throw new Error('Invalid name');
  return db.users.create(data);
}

function updateUser(id, data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Invalid email');
  if (!data.name || data.name.length < 2) throw new Error('Invalid name');
  return db.users.update(id, data);
}
```

## ✅ Refactoring

```javascript
// ✅ Validation extracted to single source of truth (Extract Function)
function validateUserData(data) {
  if (!data.email || !data.email.includes('@')) throw new Error('Invalid email');
  if (!data.name || data.name.length < 2) throw new Error('Invalid name');
}

function createUser(data) {
  validateUserData(data);
  return db.users.create(data);
}

function updateUser(id, data) {
  validateUserData(data);
  return db.users.update(id, data);
}
```

## Suggested Codetag

```typescript
// FIXME: Cut-and-Paste Programming — validation duplicated in create/update/patch
// TODO: Extract Function — create reusable validateUserData()
```
