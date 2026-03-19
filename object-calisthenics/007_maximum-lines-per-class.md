# Maximum Lines per Class File Limit

**ID**: STRUCTURAL-007
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

Imposes a maximum limit on the number of lines of code in a class file (entity, *service*, controller), forcing the extraction of responsibilities to other classes.

## Why it matters

Violation of the line limit is a strong indicator that the class is violating the Single Responsibility Principle (SRP), resulting in classes with low cohesion, high coupling, and extreme difficulty in maintenance and testing.

## Objective Criteria

- [ ] Class files (including declarations, methods, and properties) must have at most 50 lines of code (excluding blank lines and comments).
- [ ] Classes that reach 40 lines should be immediate candidates for refactoring.
- [ ] Individual methods must have at most 15 lines of code.

## Allowed Exceptions

- **Configuration/Initialization Classes**: Classes that only declare constants or mappings (e.g., *Mappers*, *Configuration*).
- **Test Classes**: Test *suites* where each test method is small, but the file grows due to the number of scenarios.

## How to Detect

### Manual

Visual counting or use of file metrics analysis tools.

### Automatic

SonarQube/ESLint: `max-lines-per-file: 50` and `max-lines-per-method: 5`.

## Related to

- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): reinforces
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [021 - Prohibition of Logic Duplication](../clean-code/001_prohibition-logic-duplication.md): reinforces
- [023 - Prohibition of Speculative Functionality](../clean-code/003_prohibition-speculative-functionality.md): reinforces
- [025 - Prohibition of The Blob Anti-Pattern](../clean-code/005_prohibition-blob-anti-pattern.md): reinforces
- [016 - Common Closure Principle](002_common-closure-principle.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
