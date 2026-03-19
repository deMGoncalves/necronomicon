# Single Indentation Level Restriction per Method

**ID**: STRUCTURAL-001
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Limits the complexity of a method or function by enforcing a single indentation level for code blocks (conditionals, *loops*, or *try-catch*), forcing the extraction of logic into separate methods.

## Why it matters

Reduces Cyclomatic Complexity (CC), drastically improving method readability and maintainability, and facilitating the writing of unit tests focused on a single responsibility.

## Objective Criteria

- [ ] Methods and functions must contain at most a single indentation level for code blocks (after the initial method scope).
- [ ] The use of *guard clauses* for early returns does not count as a new indentation level.
- [ ] Anonymous functions passed as *callbacks* must not introduce a second indentation level in the parent method.

## Allowed Exceptions

- **Specific Control Structures**: *Try/Catch/Finally* in error handling scope that cannot be delegated.

## How to Detect

### Manual

Check for the existence of nested code blocks (e.g., an `if` inside a `for`, or a `for` inside an `if`).

### Automatic

SonarQube/ESLint: `complexity.max-depth: 1`

## Related to

- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reinforces
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): complements
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): complements
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
