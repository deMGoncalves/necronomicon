# Error Handling (Rules 027, 028)

## Rules

- **027**: Use domain exceptions (not `return null`)
- **028**: Handle all Promises with `await` or `.catch()`

## Checklist

- [ ] Business methods return valid types or throw exception
- [ ] Prohibited `return null` or `return undefined` in business logic
- [ ] Custom exceptions for domain (`UserNotFoundError`)
- [ ] All Promises followed by `await` or `.catch()`
- [ ] No empty `catch` or that only logs

## Examples

```typescript
// ❌ Violations
function findUser(id) {
  const user = db.find(id);
  return user || null; // client must check null
}

async function handleRequest(req) {
  saveToDatabase(req.body); // floating Promise!
}

try { await operation(); } catch (e) {} // empty catch

// ✅ Compliance
class UserNotFoundError extends BaseDomainError {
  constructor(id: string) {
    super(`User ${id} not found`);
  }
}

function findUser(id: string): User {
  const user = db.find(id);
  if (!user) throw new UserNotFoundError(id);
  return user;
}

async function handleRequest(req: Request) {
  await saveToDatabase(req.body); // explicit await
}

// or with .catch()
promise.catch(err => logger.error('Failed', err));
```

## Relation to ICP

Exceptions eliminate null-check branches spread throughout code (reduces CC_base).
