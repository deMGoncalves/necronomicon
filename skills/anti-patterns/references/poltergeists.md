# Poltergeists

**Severity:** 🟡 Medium
**Associated Rule:** Rule 065

## What It Is

Classes with ephemeral and transitory role: they exist only to pass data between other classes or initialize something, with no real state or significant behavior. They disappear shortly after fulfilling their minimal role, like a poltergeist. Short-lived Middle Men.

## Symptoms

- Classes/services created only to adapt parameters or format calls and discarded
- Classes with a single public method, usually called `execute()`, `run()`, or `process()`
- Classes without attributes (stateless) that only call methods of other classes
- Controllers that only delegate to a service that only delegates to a repository
- "Orchestrators" that don't orchestrate anything — just pass calls
- Constructed objects never stored, never tested, never referenced beyond immediate call

## ❌ Example (violation)

```javascript
// ❌ Class that exists only to call another
class UserInitializer {
  constructor(userService) {
    this.userService = userService;
  }
  initialize(data) {
    return this.userService.create(data); // just this
  }
}

// Caller needs to instantiate UserInitializer just to reach UserService
const initializer = new UserInitializer(userService);
initializer.initialize(data);
```

## ✅ Refactoring

```javascript
// ✅ Call UserService directly (Inline Class)
userService.create(data);

// If the class adds real transformation or validation, then it makes sense to exist
```

## Suggested Codetag

```typescript
// FIXME: Poltergeist — UserInitializer only delegates to userService.create()
// TODO: Inline Class — call userService.create() directly
```
