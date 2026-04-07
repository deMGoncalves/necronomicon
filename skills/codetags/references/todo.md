# TODO — Pending Task

**Severity:** 🟡 Medium | Resolve in sprint
**Blocks PR:** No

## What It Is

Marks pending task or planned functionality that hasn't been implemented yet. It's the most common codetag and indicates future work that's on the team's radar.

## When to Use

- Partially implemented feature (missing edge case validation)
- Placeholder for future implementation (function with stub)
- Confirmed and planned improvement (add cache)
- Pending integration with external service

## When NOT to Use

- Bug to fix → use **FIXME**
- Code to restructure → use **REFACTOR**
- Performance optimization → use **OPTIMIZE**
- Unconfirmed future idea → use **IDEA**

## Format

```typescript
// TODO: clear task description
// TODO: [TICKET-123] description with tracking
// TODO: description - deadline if applicable
```

## Example

```typescript
// TODO: [PROJ-456] add email format validation
function createUser(email: string, password: string) {
  // Email validation pending
  return db.users.create({ email, password });
}

// TODO: implement pagination - current limit 100 items
async function listProducts() {
  return db.products.findAll({ limit: 100 });
}

// TODO: implement retry with exponential backoff
async function fetchWithRetry(url: string) {
  return fetch(url);
}
```

## Resolution

- **Timeline:** Planned sprint (blocker for feature) or next sprint (improvement)
- **Action:** Create ticket, prioritize in backlog, implement when prioritized
- **Converted to:** Removed after complete implementation

## Related to

- Rules: [023 - YAGNI](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md) (don't create speculative TODOs)
- Similar tags: TODO (confirmed) vs IDEA (not confirmed)
