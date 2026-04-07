# FIXME — Confirmed Bug Requiring Immediate Correction

**Severity:** 🔴 Critical
**Blocks PR:** Yes

## What It Is

Marks code with confirmed bug that produces incorrect behavior and must be fixed immediately. Unlike BUG (which documents known defect), FIXME indicates code needs to be corrected now.

## When to Use

- Incorrect logic discovered (calculation returning wrong value)
- Untreated edge case (division by zero, empty array)
- Unexpected behavior (function returns undefined when it shouldn't)
- Identified regression (code that worked and stopped)

## When NOT to Use

- Known but not urgent bug → use BUG
- Code works but is ugly → use REFACTOR
- Performance improvement → use OPTIMIZE
- Security vulnerability → use SECURITY

## Format

```typescript
// FIXME: problem description - identified cause
// FIXME: [ticket-123] problem description
// FIXME: problem description
```

## Example

```typescript
// FIXME: division by zero when items is empty
function calculateAverage(items: number[]): number {
  const sum = items.reduce((a, b) => a + b, 0);
  return sum / items.length; // 💥 NaN if items = []
}

// ✅ Fixed
function calculateAverage(items: number[]): number {
  if (items.length === 0) return 0;
  const sum = items.reduce((a, b) => a + b, 0);
  return sum / items.length;
}
```

## Resolution

- **Timeline:** Before commit/merge
- **Action:** Identify root cause → Fix → Test with edge cases → Remove comment
- **Converted to:** N/A (removed after correction)

## Related to

- Rules: [027](../../../.claude/rules/027_qualidade-tratamento-erros-dominio.md), [039](../../../.claude/rules/039_regra-escoteiro-refatoracao-continua.md)
- Similar tags: FIXME is immediate, BUG is planned
