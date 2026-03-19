# Application of Single Responsibility Principle (SRP)

**ID**: BEHAVIORAL-010
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Requires that a class or module have only one reason to change, which implies it must have a single responsibility.

## Why it matters

Violation of SRP causes **low cohesion** and **high coupling**, making classes fragile and difficult to test. It increases maintenance cost, as a change in one business area can break another.

## Objective Criteria

- [ ] A class must not contain business logic and persistence logic (e.g., *Service* and *Repository* together).
- [ ] The number of public methods in a class must not exceed **7**.
- [ ] The **Lack of Cohesion in Methods (LCOM)** must be less than 0.75.

## Allowed Exceptions

- **Utility/Helper Classes**: Static classes that group pure stateless functions for generic data manipulation (e.g., date formatters).

## How to Detect

### Manual

Ask: "If there is a change in requirement X and requirement Y, does this class need to be changed in both situations?" (SRP violated if the answer is yes).

### Automatic

SonarQube: High `Cognitive Complexity` and high `LCOM (Lack of Cohesion in Methods)`.

## Related to

- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reinforces
- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): complements
- [025 - Prohibition of The Blob Anti-Pattern](../clean-code/005_prohibition-blob-anti-pattern.md): complements
- [021 - Prohibition of Logic Duplication](../clean-code/001_prohibition-logic-duplication.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): reinforces
- [015 - Release Reuse Equivalency Principle](001_release-reuse-equivalency-principle.md): reinforces
- [016 - Common Closure Principle](002_common-closure-principle.md): reinforces
- [032 - Minimum Test Coverage](../clean-code/012_minimum-test-coverage.md): reinforces
- [033 - Parameter Limit per Function](../clean-code/013_parameter-limit-per-function.md): reinforces
- [034 - Consistent Class and Method Names](../clean-code/014_consistent-class-method-names.md): reinforces
- [037 - Prohibition of Flag Arguments](../clean-code/017_prohibition-flag-arguments.md): reinforces
- [038 - Query Inversion Principle](../clean-code/018_query-inversion-principle.md): reinforces
- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): complements
- [047 - Concurrency via Processes](../twelve-factor/008_concurrency-via-processes.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
