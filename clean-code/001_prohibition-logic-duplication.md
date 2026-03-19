# Prohibition of Logic Duplication (DRY Principle)

**ID**: STRUCTURAL-021
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

Requires that each piece of knowledge have a unique, unambiguous, and authoritative representation within the system. Prohibits duplication of logic or functionally identical code.

## Why it matters

Duplication creates severe technical debt, as a change requires modifying N other duplicated sections, exponentially increasing regression bug risk and maintenance cost.

## Objective Criteria

- [ ] Direct copying of code blocks with more than **5** lines between classes or methods is prohibited.
- [ ] Complex logic used in more than **2** locations should be extracted into a reusable function or class.
- [ ] Reuse should be done via abstraction (function, class, interface) and not via *copy-paste*.

## Allowed Exceptions

- **Low-Level Configurations**: Small repetitions in configuration files or purely structural DTOs.
- **Unit Tests**: Configuration of *fixtures* or *setups* for specific test scenarios.

## How to Detect

### Manual

Search for code sections that appear identical but have small variations (subtle duplication).

### Automatic

SonarQube/ESLint: `no-duplicated-code` (with semantic analysis).

## Related to

- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements
- [040 - Single Codebase](../twelve-factor/001_single-codebase.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
