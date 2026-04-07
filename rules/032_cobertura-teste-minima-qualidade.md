# Minimum Test Coverage and Quality (TDD)

**ID**: COMPORTAMENTAL-032
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Establishes a mandatory minimum **Code Coverage** limit for the Domain/Business Module (Use Cases and Entities) and requires unit tests to follow the AAA (*Arrange, Act, Assert*) principle.

## Why It Matters

Ensures **reliability** and facilitates refactoring. Code without high-quality unit tests is fragile and violates the OCP (Open/Closed Principle).

## Objective Criteria

- [ ] Line test coverage (Line Coverage) must be at least **85%** for all domain/business modules.
- [ ] Using control logic (e.g., `if`, `for`, `while`) directly inside a unit test body is prohibited.
- [ ] Each unit test should focus on a single assertion (maximum 2) and follow the AAA structure (Arrange, Act, Assert).

## Allowed Exceptions

- **Initialization Modules**: Configuration files and *root composers* (which do not contain business logic) may have low or zero coverage.

## How to Detect

### Manual

Search for `if` or `for` inside `test()` or `it()` blocks.

### Automatic

Bun Test Runner/Jest: Configuration of `coverageThresholds`.

## Related To

- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements
- [049 - Dev/Prod Parity](049_paridade-dev-prod.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
