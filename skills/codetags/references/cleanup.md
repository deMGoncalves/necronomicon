# CLEANUP — Disorganized Code or Unnecessary Elements

**Severity:** 🟠 High
**Blocks PR:** No (but should be addressed)

## What It Is

Marks disorganized code or unnecessary elements that need to be cleaned. Unlike REFACTOR (which changes structure), CLEANUP removes noise and organizes without altering behavior.

## When to Use

- Dead code (never-called functions)
- Unused imports (orphan dependencies)
- Obsolete comments (outdated documentation)
- Forgotten console.logs (debug left behind)
- Unused variables (orphan declarations)

## When NOT to Use

- Code to be restructured → use REFACTOR
- Bug to be fixed → use FIXME
- Feature to implement → use TODO
- Official obsolete code → use DEPRECATED

## Format

```typescript
// CLEANUP: type of cleanup needed
// CLEANUP: remove dead code after confirming non-use
// CLEANUP: organize imports/remove unused
```

## Example

```typescript
// CLEANUP: unused function - verify and remove
function oldCalculation(value: number): number {
  // This function was used in v1, no longer called
  return value * 1.5;
}

// CLEANUP: remove debug logs before merge
function processOrder(order: Order): Result {
  console.log('DEBUG: order received', order);
  console.log('DEBUG: processing...', { timestamp: Date.now() });

  const result = calculate(order);

  console.log('DEBUG: result', result);
  return result;
}

// CLEANUP: unused imports - remove
import { useState, useEffect, useCallback, useMemo } from 'react';
import { format, parse, addDays } from 'date-fns';
import _ from 'lodash';

// Only useState is used
function SimpleComponent(): JSX.Element {
  const [value, setValue] = useState(0);
  return <div>{value}</div>;
}

// CLEANUP: outdated comments - update or remove
function calculateDiscount(order: Order): number {
  // Returns 10% discount for orders above R$100
  // NOTE: now returns 15% (changed in 2023)
  // TODO: verify with marketing (already verified, keep 15%)
  return order.total > 100 ? order.total * 0.15 : 0;
}

// CLEANUP: commented code - remove (it's in git history)
function getCurrentPrice(product: Product): number {
  // const oldPrice = product.basePrice * 1.1;
  // const discount = calculateOldDiscount(product);
  // return oldPrice - discount;

  return product.basePrice * 1.2;
}
```

## Resolution

- **Timeline:** Before commit (console.logs) or before PR (imports) or next sprint (dead code)
- **Action:** Identify cleanup type → Verify removal is safe → Remove code/imports/comments → Test nothing broke → Commit
- **Converted to:** N/A (removed after cleanup)

## Related to

- Rules: [023](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md), [039](../../../.claude/rules/039_regra-escoteiro-refatoracao-continua.md)
- Similar tags: CLEANUP removes noise, REFACTOR changes structure
