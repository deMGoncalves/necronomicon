# Immutability and State (Rules 029, 036, 038)

## Rules

- **029**: Immutable Value Objects and Entities (`Object.freeze()`)
- **036**: Pure functions (no side effects in Queries)
- **038**: Command-Query Separation (CQS)

## Checklist

- [ ] Value Objects frozen with `Object.freeze()`
- [ ] Queries don't modify state
- [ ] Mutable objects cloned before modifying
- [ ] Commands with verbal names (`update`, `save`, `delete`)
- [ ] Methods are Query XOR Command (never hybrid)

## Examples

```typescript
// ❌ Violations
// Mutability (029)
function createProduct(data) {
  return { id: data.id, price: data.price }; // mutable!
}
const product = createProduct({ id: 1, price: 50 });
product.price = 0; // accidental mutation

// Hidden side effect (036)
function getActiveUsers(users) {
  return users.filter(u => {
    if (!u.active) u.lastChecked = Date.now(); // side effect!
    return u.active;
  });
}

// CQS violated (038)
function getAndActivateUser(id) { // hybrid Query+Command
  const user = db.find(id);
  user.active = true;
  db.save(user);
  return user;
}

// ✅ Compliance
// Immutability
function createProduct(data: ProductData) {
  return Object.freeze({ id: data.id, price: data.price });
}

interface Product {
  readonly id: number;
  readonly price: number;
}

// Pure Query
function getActiveUsers(users: User[]): User[] {
  return users.filter(u => u.active);
}

// Explicit Command
function markInactiveUsers(users: User[]) {
  users.filter(u => !u.active).forEach(u => {
    u.lastChecked = Date.now();
  });
}

// CQS: Query and Command separated
function findUser(id: string): User { // Query
  return db.find(id);
}

function activateUser(id: string): void { // Command
  const user = db.find(id);
  user.active = true;
  db.save(user);
}
```

## Relation to ICP

- Immutability eliminates mutation responsibilities
- Pure functions have lower CC_base (no state branches)
- CQS separates responsibilities (Query ≠ Command)
