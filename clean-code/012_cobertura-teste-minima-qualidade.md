# Minimum Test Coverage and Quality (TDD)

**ID**: BEHAVIORAL-032
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Establishes a mandatory minimum limit for **Code Coverage** for the Domain/Business Module (Use Cases and Entities) and requires that unit tests follow the AAA (*Arrange, Act, Assert*) principle.

## Why it matters

Ensures **reliability** and facilitates refactoring. Code without high-quality unit tests is fragile and violates the OCP (Open/Closed Principle).

## Objective Criteria

- [ ] Line Coverage for tests must be at least **85%** for all domain/business modules.
- [ ] Using control logic (e.g., `if`, `for`, `while`) directly inside a unit test body is prohibited.
- [ ] Each unit test should focus on a single assertion (maximum 2) and follow the AAA structure (Arrange, Act, Assert).

## Allowed Exceptions

- **Initialization Modules**: Configuration files and *root composers* (which do not contain business logic) may have low or zero coverage.

## How to Detect

### Manual

Search for `if` or `for` inside `test()` or `it()` blocks.

### Automatic

Bun Test Runner/Jest: `coverageThresholds` configuration.

## Related to

- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): complements
- [049 - Dev/Prod Parity](../twelve-factor/010_paridade-dev-prod.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
