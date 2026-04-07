# XXX — Alert for Dangerous or Fragile Code

**Severity:** 🔴 Critical
**Blocks PR:** Yes (or strong justification)

## What It Is

Marks code requiring immediate critical attention — indicates something dangerous, problematic or that may cause severe issues. It's a "warning cry" in code that must not be ignored.

## When to Use

- Extremely fragile code (can break with any change)
- Dangerous non-obvious logic (counter-intuitive behavior)
- Critical order dependency (sequence that cannot be altered)
- Trap for developers (code that looks OK but isn't)

## When NOT to Use

- Confirmed bug → use FIXME or BUG
- Security vulnerability → use SECURITY
- Temporary code → use HACK
- Code to be refactored → use REFACTOR

## Format

```typescript
// XXX: ALERT - danger description
// XXX: DO NOT ALTER - critical reason
// XXX: CAUTION - risk explanation
```

## Example

```typescript
// XXX: CRITICAL ORDER - these lines MUST execute in this sequence
// Reversing causes race condition that corrupts user data
await lockAccount(userId);
await processPayment(userId, amount);
await unlockAccount(userId);
// If unlockAccount executes before processPayment, double-charge occurs

// XXX: CAUTION - this function MODIFIES original array
// Looks like returning new array but mutates in-place for performance
// DO NOT pass array that needs to be preserved
function processItems<T>(items: T[]): T[] {
  items.sort((a, b) => a.priority - b.priority);
  items.splice(0, Math.floor(items.length / 2));
  return items; // Same array, modified!
}

// XXX: FRAGILE - depends on specific browser timing
// Works because DOM updates in ~16ms
// Any change can break silently
setTimeout(() => {
  element.classList.add('visible');
}, 20); // DO NOT ALTER this value
```

## Resolution

- **Timeline:** Before merge (new code) or plan refactoring (legacy code)
- **Action:** Read warning carefully → Understand risk completely → Consult author → Test exhaustively → Document → Remove XXX only when rewritten safely
- **Converted to:** Removed or converted to REFACTOR if migration planned

## Related to

- Rules: [022](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md), [026](../../../.claude/rules/026_qualidade-comentarios-porque.md)
- Similar tags: XXX is danger alert, FIXME is bug to fix, SECURITY is vulnerability, HACK is temporary
