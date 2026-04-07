# Golden Hammer

**Severity:** 🟡 Medium
**Associated Rule:** Rule 068

## What It Is

Using a familiar technology, tool, or pattern to solve all problems, regardless of whether it's the most suitable solution. "If the only tool you have is a hammer, everything looks like a nail." — Abraham Maslow.

## Symptoms

- Same tool/pattern applied in 3+ significantly different contexts
- The same database, framework, or pattern is applied in very different contexts
- Technical decisions based on familiarity, not suitability to the problem
- Resistance to evaluating alternatives: "we already use X for everything, let's use it here too"
- Using microservice pattern in systems where single monolith would suffice
- Using NoSQL database in strongly relational systems or vice versa
- Overpowered solutions for simple problems (e.g., Kafka for 10 messages/day)

## ❌ Example (violation)

```javascript
// ❌ Using Redis (distributed cache) to store config that changes once per week
const config = await redis.get('app:config');
// Overpowered solution: a JSON file or environment variable would solve it

// ❌ Using GraphQL for an API with 2 simple endpoints
// because "we use GraphQL for everything"
```

## ✅ Refactoring

```javascript
// ✅ Solution proportional to problem (KISS + Right Tool for the Job)
import config from './config.json'; // or process.env.CONFIG

// ✅ Simple REST for simple API
app.get('/users/:id', getUserHandler);
app.post('/users', createUserHandler);
```

## Suggested Codetag

```typescript
// FIXME: Golden Hammer — Redis for static config (overkill)
// TODO: Use config.json or env vars; reserve Redis for real cache
```
