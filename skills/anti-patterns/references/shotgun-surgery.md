# Shotgun Surgery

**Severity:** 🟠 High
**Associated Rule:** Rule 058

## What It Is

A single logical change requires alterations in many different places in the code simultaneously. Each time something changes, you "shoot" edits throughout the codebase like shotgun pellets. Opposite of Divergent Change: here, one change requires N altered files.

## Symptoms

- Behavior change requires altering 3+ classes/modules
- Same calculation or validation logic exists in multiple locations
- Adding new field/feature requires modifying N files in different layers
- Bug fix needs to be applied in multiple files with same correction pattern
- Code review: "why did you also change this file?"

## ❌ Example (violation)

```javascript
// ❌ Adding "phone" field requires editing all these files:
// user.model.js      → add field
// user.validator.js  → add validation
// user.dto.js        → add to DTO
// user.mapper.js     → add to mapping
// user.repository.js → add to query
// user.test.js       → add to fixtures
```

## ✅ Refactoring

```javascript
// ✅ Cohesive feature: schema centralizes everything (Move Method + Move Field)
const userSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  phone: z.string().regex(/^\+\d{10,15}$/), // add here → works system-wide
});

// Type inference + validation + DTO + mapping = all in one place
type User = z.infer<typeof userSchema>;
```

## Suggested Codetag

```typescript
// FIXME: Shotgun Surgery — adding field requires N files: model, validator, dto, mapper, repository
// TODO: Centralize schema with Zod/Yup for unified validation + types + DTOs
```
