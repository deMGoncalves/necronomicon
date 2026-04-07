# Correctness — Corretude

**Dimension:** Operation
**Default Severity:** 🔴 Critical
**Key Question:** Does it do what is requested?

## What It Is

The degree to which software meets its specifications and fulfills user objectives. Correct software produces expected results for all valid inputs and properly handles edge cases.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Bug affects user data | 🔴 Blocker |
| Bug affects critical calculations (financial) | 🔴 Blocker |
| Bug in rare edge case | 🟠 Important |
| Cosmetic UI bug | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Incorrect - doesn't consider edge cases
function calculateDiscount(price, quantity) {
  return price * quantity * 0.1; // What if quantity is 0 or negative?
}

// ✅ Correct - handles edge cases
function calculateDiscount(price, quantity) {
  if (quantity <= 0) return 0;
  if (price <= 0) return 0;
  return price * quantity * 0.1;
}
```

## Suggested Codetags

```javascript
// FIXME: Division by zero when items is empty
// BUG: Incorrect comparison between types — use ===
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Bug affects user data | 🔴 Blocker |
| Bug affects critical calculations | 🔴 Blocker |
| Bug in rare edge case | 🟠 Important |
| Cosmetic bug | 🟡 Suggestion |

## Related Rules

- 027 - Domain Error Handling Quality
- 028 - Asynchronous Exception Handling
- 002 - Prohibition of ELSE Clause
