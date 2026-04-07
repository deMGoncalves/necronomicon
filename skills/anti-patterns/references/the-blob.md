# The Blob (God Object)

**Severity:** 🔴 Critical
**Associated Rule:** Rule 025

## What It Is

A single class or module accumulates most of the system's logic, controlling data and behaviors that should be distributed among multiple classes with well-defined responsibilities.

## Symptoms

- Class with hundreds or thousands of lines
- Dozens of methods without cohesion between them
- Almost all system code imports this class
- Difficult to test in isolation — depends on everything and everything depends on it
- Changes in this class break unrelated functionalities

## ❌ Example (violation)

```javascript
// ❌ One class managing user, authentication, email and report
class App {
  createUser(data) { ... }
  login(email, password) { ... }
  sendWelcomeEmail(user) { ... }
  generateReport(filters) { ... }
  exportToPDF(report) { ... }
  validateCreditCard(card) { ... }
}
```

## ✅ Refactoring

```javascript
// ✅ Each class with a single responsibility
class UserRepository { createUser(data) { ... } }
class AuthService { login(email, password) { ... } }
class EmailService { sendWelcomeEmail(user) { ... } }
class ReportService { generateReport(filters) { ... } }
```

## Suggested Codetag

```typescript
// FIXME: The Blob — App class has 8+ distinct responsibilities
// TODO: Extract UserRepository, AuthService, EmailService, ReportService
```
