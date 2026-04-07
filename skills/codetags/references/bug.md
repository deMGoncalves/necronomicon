# BUG — Known Documented and Tracked Defect

**Severity:** 🔴 Critical
**Blocks PR:** No (but should be prioritized)

## What It Is

Documents a known defect that causes failure or unexpected behavior, but is being tracked and will be fixed in planned moment. Unlike FIXME (immediate correction), BUG indicates a documented problem with associated ticket/issue.

## When to Use

- Defect with open ticket (reported and prioritized bug in backlog)
- Known problem with workaround (users temporarily work around it)
- Third-party bug awaiting fix (dependency with open issue)
- Intermittent problem under investigation (race condition hard to reproduce)

## When NOT to Use

- Bug needing immediate fix → use FIXME
- Code works but is bad → use REFACTOR
- Security problem → use SECURITY
- Temporary code → use HACK

## Format

```typescript
// BUG: problem description - ticket/issue
// BUG: [JIRA-123] incorrect behavior description
// BUG: description - workaround: how to work around
```

## Example

```typescript
// BUG: [PROJ-456] toast notification doesn't appear on Safari iOS
// Workaround: users can see notifications on history page
function showNotification(message: string): void {
  toast.show(message); // Doesn't work on Safari iOS < 15
}

// BUG: race condition when multiple requests arrive simultaneously
// Occurs in ~2% of high traffic cases
// Investigation in progress - ticket PERF-789
async function processOrder(order: Order): Promise<void> {
  const inventory = await getInventory();
  // Inventory can change between get and update
  await updateInventory(order);
}
```

## Resolution

- **Timeline:** Current sprint (critical) or next 2 sprints (with workaround)
- **Action:** Document → Create ticket → Add reference → Document workaround → Prioritize → Remove after correction
- **Converted to:** N/A (removed after correction)

## Related to

- Rules: [027](../../../.claude/rules/027_qualidade-tratamento-erros-dominio.md), [032](../../../.claude/rules/032_cobertura-teste-minima-qualidade.md)
- Similar tags: BUG is planned, FIXME is immediate
