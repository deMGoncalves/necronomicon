# INFO — Additional Technical Information

**Severity:** 🟢 Low | Informative
**Blocks PR:** No

## What It Is

Marks additional technical information or explanation that helps understand code. Less critical than NOTE - it's useful context but not essential for modifying code.

## When to Use

- Reference to external documentation (link to spec or RFC)
- Algorithm explanation (how it works internally)
- Technical context (library limitation)
- Usage example (how function is called)

## When NOT to Use

- Important decision → use **NOTE**
- Pending task → use **TODO**
- Dangerous code → use **XXX**
- API documentation → use JSDoc/TSDoc

## Format

```typescript
// INFO: additional technical detail
// INFO: documentation reference
// INFO: algorithm or pattern explanation
```

## Example

```typescript
// INFO: implementation based on Web Crypto API
// Spec: https://www.w3.org/TR/WebCryptoAPI/
async function generateKey() {
  return crypto.subtle.generateKey(
    { name: 'AES-GCM', length: 256 },
    true,
    ['encrypt', 'decrypt']
  );
}

// INFO: Fisher-Yates shuffle - O(n) with uniform distribution
// Each element has equal probability of being in any position
function shuffle<T>(array: T[]): T[] {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

// INFO: date-fns doesn't support native timezone
// For timezone operations, use date-fns-tz
import { format } from 'date-fns';

// INFO: typical usage:
// const result = pipe(double, addOne, square)(5); // ((5 * 2) + 1)² = 121
function pipe<T>(...fns: Array<(arg: T) => T>) {
  return (value: T) => fns.reduce((acc, fn) => fn(acc), value);
}

// INFO: expected response format:
// { "data": { "user": { "id": "123", "name": "John" } } }
async function fetchUser(id: string) {
  const response = await api.get(`/users/${id}`);
  return response.data.user;
}

// INFO: useEffect with empty array executes only on mount
// Equivalent to componentDidMount in class components
useEffect(() => {
  initializeAnalytics();
}, []);

// INFO: 86400000 = 24h * 60min * 60s * 1000ms
// Represents one full day in milliseconds
const ONE_DAY_MS = 86400000;
```

## Resolution

- **Timeline:** N/A (informative, optional reading)
- **Action:** Read if need to understand details, ignore if already know, update if links break, remove if trivial
- **Converted to:** Removed if information is common or updated if link breaks

## Related to

- Rules: [026 - Comments Quality](../../../.claude/rules/026_qualidade-comentarios-porque.md) (INFO complements, doesn't replace good code)
- Similar tags: INFO (extra context) vs NOTE (critical decision)
