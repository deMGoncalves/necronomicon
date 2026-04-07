# Efficiency — Eficiência

**Dimension:** Operation
**Default Severity:** 🟠 Important
**Key Question:** Does it have good performance?

## What It Is

The amount of computational resources and code required for software to perform its functions. Efficiency encompasses execution time (CPU), memory usage, bandwidth consumption, and I/O optimization.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Critical performance (< 100ms required) | 🔴 Blocker |
| List with 10k+ items | 🟠 Important |
| List with < 100 items | 🟡 Suggestion |
| Rarely executed code | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Inefficient - unnecessary O(n²)
function findDuplicates(items) {
  const duplicates = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (items[i] === items[j]) {
        duplicates.push(items[i]);
      }
    }
  }
  return duplicates;
}

// ✅ Efficient - O(n) with Set
function findDuplicates(items) {
  const seen = new Set();
  const duplicates = new Set();

  for (const item of items) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }

  return [...duplicates];
}
```

## Suggested Codetags

```javascript
// OPTIMIZE: This O(n²) loop can be O(n) with Set
// PERFORMANCE: N+1 queries - consider batch loading
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Critical performance (< 100ms required) | 🔴 Blocker |
| List with 10k+ items | 🟠 Important |
| List with < 100 items | 🟡 Suggestion |
| Rarely executed code | 🟡 Suggestion |

## Related Rules

- 022 - Prioritization of Simplicity and Clarity
- 001 - Single Indentation Level
- 055 - Maximum Lines per Method
