# DEPRECATED — Obsolete Code to be Removed

**Severity:** 🟠 High
**Blocks PR:** No (but must follow timeline)

## What It Is

Marks obsolete code or functionality that will be removed in future version. Indicates better alternative exists and current usage should be migrated.

## When to Use

- API being discontinued (v1 endpoint being replaced by v2)
- Function with better replacement (old helper with new implementation)
- Abandoned pattern (approach no longer maintained)
- Dependency to be removed (library being changed)

## When NOT to Use

- Code with bug → use FIXME or BUG
- Temporary code → use HACK
- Code to improve → use REFACTOR
- Removed code → delete, don't mark

## Format

```typescript
// DEPRECATED: use X instead - remove in vY.Z
// @deprecated since v1.2 - use newFunction()
// DEPRECATED: [timeline] migration description
```

## Example

```typescript
// DEPRECATED: use calculateTotalV2() - remove in v3.0
// This function doesn't consider regional taxes
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// New recommended function
function calculateTotalV2(items: Item[], region: string): number {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  return applyRegionalTax(subtotal, region);
}

/**
 * @deprecated since v2.0 - use newFunction() instead
 * @see newFunction
 */
function oldFunction(): void {
  if (process.env.NODE_ENV === 'development') {
    console.warn('oldFunction() is deprecated. Use newFunction() instead.');
  }
  // ...
}

// DEPRECATED: JSON configuration - migrate to environment variables
// JSON config will be removed in v4.0 (twelve-factor compliance)
const config = require('./config.json');

// New pattern
const config = {
  apiUrl: process.env.API_URL,
  apiKey: process.env.API_KEY,
};
```

## Resolution

- **Timeline:** Announcement → Grace period (dev warnings) → Warning (optional prod warnings) → Removal
- **Action:** Document alternative → Define timeline → Communicate consumers → Add runtime warning (dev) → Migrate internal uses → Remove after period
- **Converted to:** Code removed after deprecation period

## Related to

- Rules: [023](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md), [015](../../../.claude/rules/015_principio-equivalencia-lancamento-reuso.md)
- Similar tags: DEPRECATED has timeline and alternative, dead code is deleted immediately
