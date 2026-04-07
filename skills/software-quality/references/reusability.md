# Reusability — Reusabilidade

**Dimension:** Transition
**Default Severity:** 🟠 Important
**Key Question:** Can it be used in another context?

## What It Is

The degree to which a module or component can be reused in other systems or contexts beyond the one for which it was originally developed. High reusability means components are generic, well documented, and have clear interfaces.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Duplicated business logic | 🟠 Important |
| Utility coupled to domain | 🟠 Important |
| Too specific UI component | 🟡 Suggestion |
| Context-specific naming | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not reusable - duplicated logic
// file1.js
function validateUserEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// file2.js
function checkEmailFormat(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// ✅ Reusable - single shared function
// shared/validators.js
export function isValidEmail(email) {
  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return EMAIL_REGEX.test(email);
}
```

## Suggested Codetags

```javascript
// DRY(021): This logic is duplicated in another file
// REUSE: Component too specific - generalize
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Duplicated business logic | 🟠 Important |
| Utility coupled to domain | 🟠 Important |
| Too specific UI component | 🟡 Suggestion |
| Context-specific naming | 🟡 Suggestion |

## Related Rules

- 021 - Prohibition of Logic Duplication
- 003 - Primitive Encapsulation
- 010 - Single Responsibility Principle
