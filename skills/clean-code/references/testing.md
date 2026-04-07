# Testing (Rule 032)

## Rule

- **032**: Coverage ≥85% for domain/business modules (AAA pattern)

## Checklist

- [ ] Line Coverage ≥85% in domain/business (Use Cases, Entities)
- [ ] No control logic (`if`, `for`, `while`) inside tests
- [ ] Each test focuses on 1-2 assertions (maximum)
- [ ] AAA structure (Arrange, Act, Assert)

## Examples

```typescript
// ❌ Violations
test('user operations', () => {
  const user = createUser({ name: 'Alice' });

  // Control logic in test
  if (user.isAdmin) {
    expect(user.permissions).toContain('admin');
  } else {
    expect(user.permissions).toContain('user');
  }

  // Multiple unrelated assertions
  expect(user.name).toBe('Alice');
  expect(user.email).toContain('@');
  expect(user.age).toBeGreaterThan(0);
});

// ✅ Compliance
describe('User', () => {
  test('should create user with provided name', () => {
    // Arrange
    const input = { name: 'Alice', email: 'alice@example.com' };

    // Act
    const user = createUser(input);

    // Assert
    expect(user.name).toBe('Alice');
  });

  test('should validate email during creation', () => {
    // Arrange
    const input = { name: 'Bob', email: 'invalid' };

    // Act & Assert
    expect(() => createUser(input)).toThrow(EmailInvalidError);
  });

  test('admin should have administrator permission', () => {
    // Arrange
    const admin = createUser({ name: 'Admin', role: 'admin' });

    // Act
    const permissions = admin.getPermissions();

    // Assert
    expect(permissions).toContain('admin');
  });
});

// Explicit AAA structure
test('should calculate discount for premium user', () => {
  // Arrange
  const user = { premium: true, purchases: 15 };

  // Act
  const discount = calculateDiscount(user);

  // Assert
  expect(discount).toBe(0.2);
});
```

## Relation to ICP

- Tests without control logic are easier to understand
- AAA makes purpose and expectation explicit
- High coverage ensures CC_base was exercised
