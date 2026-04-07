# Code Structure (Rules 021, 022, 023, 024, 026)

## Rules

- **021**: DRY — no logic duplication
- **022**: KISS — Cyclomatic Complexity ≤5
- **023**: YAGNI — no speculative functionality
- **024**: No magic constants
- **026**: Comments explain WHY, not WHAT

## Checklist

- [ ] No copy-paste of blocks >5 lines
- [ ] Logic used >2x → extract to reusable function
- [ ] CC of each method ≤5
- [ ] No empty classes/methods "for the future"
- [ ] No unused parameters
- [ ] Numeric values (except 0/1) in named constants
- [ ] Domain strings in Enums or constants
- [ ] Comments justify non-obvious decisions

## Examples

```typescript
// ❌ Violations
// Duplication (021)
function validateEmailInService(email) {
  if (!email || !email.includes('@')) throw new Error('Invalid');
}
function validateEmailInController(email) {
  if (!email || !email.includes('@')) throw new Error('Invalid'); // duplicated!
}

// Magic constant (024)
if (user.age >= 18 && user.score > 100) { } // 18 and 100 are magic

// YAGNI (023)
class UserService {
  exportToCsv() { /* TODO: implement later */ } // speculative
}

// Redundant comment (026)
function getUser(id) {
  // fetches user by id
  return db.find(id); // obvious!
}

// ✅ Compliance
// DRY
function validateEmail(email: string) {
  if (!email || !email.includes('@')) throw new EmailInvalidError();
}

// No magic constants
const LEGAL_AGE = 18;
const MIN_PREMIUM_SCORE = 100;
if (user.age >= LEGAL_AGE && user.score > MIN_PREMIUM_SCORE) { }

// Useful comment (WHY)
function getUser(id: string) {
  // Search by string ID for compatibility with legacy API v1
  return db.find(String(id));
}
```

## Relation to ICP

- DRY reduces Responsibilities (logic in one place)
- KISS keeps CC_base low
- Named constants are self-documented (less cognitive load)
