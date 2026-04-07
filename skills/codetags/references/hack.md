# HACK — Temporary Solution or Workaround

**Severity:** 🟠 High
**Blocks PR:** No (but must be documented)

## What It Is

Marks temporary solution or workaround that works but isn't the correct implementation. HACKs are consciously sub-optimal and need to be properly rewritten.

## When to Use

- Workaround for external bug (working around library bug)
- Quick solution for deadline (needs refactoring later)
- Compatibility code (temporary support for old version)
- Gambiarra that works (non-elegant but functional solution)

## When NOT to Use

- Bug in own code → use FIXME
- Code needing improvement → use REFACTOR
- Pending optimization → use OPTIMIZE
- Permanent code → don't use codetag

## Format

```typescript
// HACK: workaround reason - when to remove
// HACK: [ticket] description - remove when X
// HACK: working around bug in lib Y - issue #123
```

## Example

```typescript
// HACK: Safari doesn't support `gap` in flexbox < 14.1
// Remove when dropping Safari 14 support
const styles = {
  display: 'flex',
  // gap: '16px', // Doesn't work on old Safari
  margin: '-8px',
  '& > *': { margin: '8px' }
};

// HACK: API v1 returns dates as string, v2 as timestamp
// Remove when migration to v2 is complete
function parseDate(value: string | number): Date {
  if (typeof value === 'string') {
    return new Date(value); // API v1
  }
  return new Date(value * 1000); // API v2
}

// HACK: inline validation for now - extract to validator class
// TODO: Create OrderValidator after 2.0 release
function createOrder(data: OrderData): Order {
  if (!data.items?.length) throw new Error('Items required');
  if (!data.customer?.email) throw new Error('Email required');
  if (data.total < 0) throw new Error('Invalid total');
  // ... rest of function
}
```

## Resolution

- **Timeline:** Next sprint (deadline) or when fix available (external bug)
- **Action:** Clearly document reason → Specify when to remove → Create ticket → Review periodically → Remove when correct solution implemented
- **Converted to:** Removed or converted to permanent code after refactoring

## Related to

- Rules: [022](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md), [039](../../../.claude/rules/039_regra-escoteiro-refatoracao-continua.md)
- Similar tags: HACK works but poorly, FIXME doesn't work (bug)
