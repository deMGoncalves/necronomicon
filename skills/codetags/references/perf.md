# PERF — Performance Bottleneck

**Severity:** 🟡 Medium | Resolve in current sprint if affecting users
**Blocks PR:** No (but should be prioritized)

## What It Is

Marks identified performance bottleneck that is causing or may cause real problems. More urgent than OPTIMIZE - indicates problem already measured or observed in production.

## When to Use

- Bottleneck measured with metrics (query taking > 1s)
- Problem observed by users (UI freezing)
- Resource limit reached (identified memory leak)
- Frequent timeout (API expiring in > 10% of requests)

## When NOT to Use

- Theoretical optimization without measurement → use **OPTIMIZE**
- Incorrect code → use **FIXME**
- Structure improvement → use **REFACTOR**
- Suspicion without measurement → measure first

## Format

```typescript
// PERF: bottleneck description - measured metric
// PERF: [p95: 2.5s] description - target: 500ms
// PERF: description - impact: X affected users
```

## Example

```typescript
// PERF: [p95: 3.2s] query without index - add index on user_id
// Target: < 100ms | Affects: orders page
async function getOrderHistory(userId: string) {
  return db.query(`
    SELECT * FROM orders
    WHERE user_id = ?
    ORDER BY created_at DESC
  `, [userId]);
}

// PERF: memory leak - event listeners not removed
// Memory grows 50MB/hour in continuous use
function setupListeners(element: HTMLElement) {
  window.addEventListener('resize', handleResize);
  window.addEventListener('scroll', handleScroll);
  // Missing: cleanup function to remove listeners
}

// PERF: [+250KB] full lodash import
// Impact: +1.5s in mobile LCP
import _ from 'lodash';
const result = _.pick(data, ['id', 'name']);

// PERF: re-render on each keystroke - debounce needed
// CPU: 100% during fast typing
function SearchComponent() {
  const [query, setQuery] = useState('');
  useEffect(() => {
    fetchResults(query); // Called on each character
  }, [query]);
  return <input onChange={e => setQuery(e.target.value)} />;
}
```

## Resolution

- **Timeline:** Immediately (users complaining) or current sprint (measurable degradation)
- **Action:** Measure current metric, define target, identify root cause, implement correction, measure again, monitor
- **Converted to:** Removed after correction confirmed by metrics

## Related to

- Rules: [022 - KISS](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md) (simple code is more performant)
- Similar tags: PERF (real problem) vs OPTIMIZE (theoretical opportunity)
