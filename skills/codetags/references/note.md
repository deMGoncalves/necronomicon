# NOTE — Important Information

**Severity:** 🟢 Low | Informative
**Blocks PR:** No

## What It Is

Marks important information about decision, context or non-obvious behavior. Unlike common comments, NOTE highlights something the reader needs to know to understand or modify code safely.

## When to Use

- Design decision (why this approach was chosen)
- Non-obvious behavior (intentional side effect)
- Historical context (reason for "strange" code)
- Important dependency (order that must be maintained)

## When NOT to Use

- Pending task → use **TODO**
- Dangerous code → use **XXX**
- Explanation of obvious → don't comment
- API documentation → use JSDoc/TSDoc

## Format

```typescript
// NOTE: important information
// NOTE: reason for technical decision
// NOTE: context affecting future maintenance
```

## Example

```typescript
// NOTE: using Map instead of Object to preserve insertion order
// and allow non-string keys (e.g., objects as key)
const cache = new Map<string, CacheEntry>();

// NOTE: null return is intentional - indicates "not found" vs error
// Caller must check: if (result === null) { handleNotFound() }
function findUser(id: string): User | null {
  const user = users.get(id);
  return user || null;
}

// NOTE: 30s timeout is payment partner requirement
// Documentation: https://docs.partner.com/timeouts
// Don't reduce without validating with them first
const PAYMENT_TIMEOUT = 30000;

// NOTE: middleware order is critical
// 1. Auth must come before rate-limit (to identify user)
// 2. Rate-limit must come before validation (to block abuse)
app.use(authMiddleware);
app.use(rateLimitMiddleware);
app.use(validationMiddleware);

// NOTE: using eager loading here despite cost
// Trade-off: +100ms on load vs N+1 queries in rendering
// Tested: eager is 3x faster in typical use case
const orders = await db.orders.findAll({
  include: [{ model: OrderItem }, { model: Customer }]
});

// NOTE: date format kept for compatibility with mobile API v1
// New endpoints use ISO 8601, but this needs to maintain DD/MM/YYYY
// Migration planned for Q3 when v1 is discontinued
function formatDateLegacy(date: Date): string {
  return format(date, 'dd/MM/yyyy');
}
```

## Resolution

- **Timeline:** N/A (informative, no action required)
- **Action:** Read before modifying code, update if information becomes outdated, remove if no longer relevant
- **Converted to:** Updated or removed when context changes

## Related to

- Rules: [026 - Comments Quality](../../../.claude/rules/026_qualidade-comentarios-porque.md) (NOTE explains the "why")
- Similar tags: NOTE (critical decision) vs INFO (technical detail)
