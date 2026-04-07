# Rule 7 — Small Classes

**deMGoncalves Rule:** ESTRUTURAL-007
**Question:** Does this class have more than 50 lines or 7 public methods?

## What It Is

Imposes a maximum limit on the number of lines of code in a class file (entity, service, controller), forcing the extraction of responsibilities to other classes.

## When to Apply

- Class with more than 50 lines of code
- Class with more than 7 public methods
- Class with more than 15 lines per method
- Class candidate for SRP violation

## ❌ Violation

```typescript
class UserService {  // 150 lines - VIOLATES
  createUser(data: UserData): User { /* 20 lines */ }
  updateUser(id: string, data: UserData): User { /* 25 lines */ }
  deleteUser(id: string): void { /* 15 lines */ }
  findUserById(id: string): User { /* 10 lines */ }
  findUserByEmail(email: string): User { /* 10 lines */ }
  listUsers(filters: Filters): User[] { /* 30 lines */ }
  exportUsers(format: string): Buffer { /* 40 lines */ }
  // ... 8 more public methods
}
```

## ✅ Correct

```typescript
// UserService.ts (30 lines)
class UserService {
  constructor(
    private readonly repository: UserRepository,
    private readonly validator: UserValidator
  ) {}

  createUser(data: UserData): User {
    this.validator.validate(data);
    return this.repository.save(new User(data));
  }

  updateUser(id: string, data: UserData): User {
    const user = this.repository.findById(id);
    user.update(data);
    return this.repository.save(user);
  }
}

// UserRepository.ts (25 lines)
class UserRepository {
  findById(id: string): User { /* ... */ }
  findByEmail(email: string): User { /* ... */ }
  save(user: User): User { /* ... */ }
  delete(id: string): void { /* ... */ }
}

// UserExporter.ts (35 lines)
class UserExporter {
  export(users: User[], format: string): Buffer { /* ... */ }
}
```

## Exceptions

- **Configuration Classes**: Classes that only declare constants or mappings
- **Test Classes**: Test suites where each test is small

## Related Rules

- [001 - Single Indentation Level](rule-01-single-indentation.md): reinforces
- [004 - First Class Collections](rule-04-first-class-collections.md): reinforces
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): reinforces
