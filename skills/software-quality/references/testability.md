# Testability — Testabilidade

**Dimension:** Revision
**Default Severity:** 🔴 Critical
**Key Question:** Is it easy to test?

## What It Is

The effort required to test software and ensure it works correctly. High testability means components can be tested in isolation, with clear inputs and outputs, without depending on external infrastructure.

## Problem Indicators

| Situation | Severity |
|----------|-----------|
| Business code impossible to test | 🔴 Blocker |
| Singleton used in critical logic | 🔴 Blocker |
| Concrete dependency in Service | 🟠 Important |
| Date.now() without injection | 🟡 Suggestion |

## Violation Example

```javascript
// ❌ Not testable - creates dependency internally
class UserService {
  async getUser(id) {
    const db = new DatabaseConnection(); // Impossible to mock
    return db.query(`SELECT * FROM users WHERE id = ${id}`);
  }
}

// ✅ Testable - dependency injected
class UserService {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async getUser(id) {
    return this.userRepository.findById(id);
  }
}

// In test:
const mockRepo = { findById: vi.fn().mockResolvedValue(mockUser) };
const service = new UserService(mockRepo);
```

## Suggested Codetags

```javascript
// TEST(014): Impossible to test - internal concrete dependency
// TEST: Need to mock time to test
```

## Severity Calibration

| Situation | Severity |
|----------|-----------|
| Business code impossible to test | 🔴 Blocker |
| Singleton used in critical logic | 🔴 Blocker |
| Concrete dependency in Service | 🟠 Important |
| Date.now() without injection | 🟡 Suggestion |

## Related Rules

- 014 - Dependency Inversion Principle
- 032 - Minimum Test Coverage
- 036 - Side Effects Function Restriction
