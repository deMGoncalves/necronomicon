# Premature Optimization

**Severity:** 🟡 Medium
**Associated Rule:** Rule 069

## What It Is

Optimizing code based on suspected slowness without measurement, before a performance problem is demonstrated. Donald Knuth: *"Premature optimization is the root of all evil."*

## Symptoms

- Optimization implemented without prior measurement (profiling, benchmark, production metrics)
- Complex algorithms where O(n²) would be imperceptible for the real data volume
- Cache implemented before any performance testing
- Unreadable code justified by "it's faster"
- Micro-optimizations in hot paths that aren't hot paths (e.g., `for` vs `map` in 20-element array)
- "Let's use Web Workers because it might be slow"

## ❌ Example (violation)

```javascript
// ❌ Manual cache due to "suspicion" it would be slow
const _userCache = new Map();
function getUser(id) {
  if (_userCache.has(id)) return _userCache.get(id);
  const user = db.find(id);       // db already has connection pool and query cache
  _userCache.set(id, user);        // cache without invalidation, without TTL, without limit
  return user;
}

// ❌ Avoid Array.map because "it's slower than for loop"
// in a 20-element array that runs once per second
```

## ✅ Refactoring

```javascript
// ✅ Make it work → Make it right → Make it fast
function getUser(id) {
  return db.find(id);
}

// After measuring and confirming it's the bottleneck:
// const getUser = memoize(db.find.bind(db), { ttl: 60_000, max: 500 });
```

## Suggested Codetag

```typescript
// FIXME: Premature Optimization — manual cache without evidence of need
// TODO: Remove cache; add only if profiling shows real bottleneck
```
