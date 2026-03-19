# Prohibition of ELSE Clause for Control Flow

**ID**: BEHAVIORAL-002
**Severity**: 🟠 High
**Category**: Behavioral

---

## What it is

Restricts the use of `else` and `else if` clauses, promoting replacement with *guard clauses* (early return) or polymorphism patterns to handle different execution paths.

## Why it matters

Improves control flow clarity, avoids unnecessary Cyclomatic Complexity, and enforces adherence to the Single Responsibility Principle (SRP), as each code block handles a specific condition.

## Objective Criteria

- [ ] The explicit use of `else` or `else if` keywords is prohibited.
- [ ] Conditionals should be used primarily as *guard clauses* (pre-condition checking and return/error throwing).
- [ ] Complex branching logic should be resolved via polymorphism (*Strategy* or *State* patterns).

## Allowed Exceptions

- **Language Control Structures**: Structures like `switch` (which generally behave like `if/else if`) may be used, provided each `case` returns or terminates execution.

## How to Detect

### Manual

Search for ` else ` or ` else if ` in the code.

### Automatic

ESLint: `no-else-return` and `no-lonely-if` with configurations to enforce early exit.

## Related to

- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): reinforces
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reinforces
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements
- [027 - Error Handling Quality](../clean-code/007_error-handling-quality.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
