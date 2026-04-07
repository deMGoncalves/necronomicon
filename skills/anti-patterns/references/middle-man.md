# Middle Man

**Severity:** 🟡 Medium
**Associated Rule:** Rule 061

## What It Is

Class that delegates most of its methods to another class without adding value of its own. If 50%+ of a class's methods just pass calls (`return this.obj.method(args)`) to another object, it's a useless Middle Man. Inverse of Feature Envy.

## Symptoms

- 50%+ of class methods are one-line delegates without adding value
- Class exists only to hide another object initially exposed directly
- Whenever you add a method to the real object, you add same wrapper to Middle Man
- Stack trace always shows same method names in two consecutive layers
- Middle Man is not used/tested in isolation — always needs the real object working

## ❌ Example (violation)

```javascript
// ❌ Manager that only passes everything to Department
class Manager {
  constructor(department) { this.department = department; }
  getEmployees() { return this.department.getEmployees(); }
  addEmployee(e) { return this.department.addEmployee(e); }
  removeEmployee(e) { return this.department.removeEmployee(e); }
  getBudget() { return this.department.getBudget(); }
}
```

## ✅ Refactoring

```javascript
// ✅ Use Department directly — Manager adds no value (Remove Middle Man)
const employees = department.getEmployees();

// If Manager has logic of its own beyond delegating, then it makes sense:
class Manager {
  approve(request) {
    // real approval logic — adds value
    if (request.amount > this.approvalLimit) throw new Error('Above limit');
    return this.department.processRequest(request);
  }
}
```

## Suggested Codetag

```typescript
// FIXME: Middle Man — Manager only delegates 5/6 methods to Department
// TODO: Remove Middle Man — expose Department directly or add real logic to Manager
```
