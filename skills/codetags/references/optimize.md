# OPTIMIZE — Optimization Opportunity

**Severity:** 🟡 Medium | Resolve when performance is problem
**Blocks PR:** No

## What It Is

Marks code that could have improved performance but works correctly. Indicates identified optimization opportunity, not an urgent problem affecting users.

## When to Use

- Inefficient algorithm (O(n²) when could be O(n))
- Non-optimized query (identified N+1 queries)
- Repeated calculation without memoization
- Unnecessary loading (excessive eager loading)

## When NOT to Use

- Critical bottleneck affecting users → use **PERF** (more urgent)
- Incorrect code → use **FIXME**
- Code to restructure → use **REFACTOR**
- Premature optimization without measurement → don't mark

## Format

```typescript
// OPTIMIZE: description - current vs ideal complexity
// OPTIMIZE: [O(n²) → O(n)] optimization description
// OPTIMIZE: description - estimated impact in milliseconds
```

## Example

```typescript
// OPTIMIZE: [O(n²) → O(n)] use Set for search instead of Array.includes
function findDuplicates(items: string[]): string[] {
  const duplicates: string[] = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (items[i] === items[j]) {
        duplicates.push(items[i]);
      }
    }
  }
  return duplicates;
}

// OPTIMIZE: N+1 queries - use batch loading
async function getUsersWithPosts(userIds: string[]) {
  const users = [];
  for (const id of userIds) {
    const user = await db.users.findById(id);
    user.posts = await db.posts.findByUserId(id); // N extra queries
    users.push(user);
  }
  return users;
}

// OPTIMIZE: recalculates on each render - add useMemo
function ExpensiveComponent({ data }: { data: Item[] }) {
  const processed = data.map(item => heavyComputation(item));
  return <List items={processed} />;
}
```

## Resolution

- **Timeline:** Current sprint (if affecting users) or technical backlog
- **Action:** Measure baseline, implement optimization, measure again
- **Converted to:** Removed after optimization or discarded if micro-optimization

## Related to

- Rules: [022 - KISS](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md) (don't complicate for micro-optimization)
- Similar tags: OPTIMIZE (opportunity) vs PERF (measured real problem)
