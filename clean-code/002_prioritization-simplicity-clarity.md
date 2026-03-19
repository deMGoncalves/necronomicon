# Prioritization of Simplicity and Clarity (KISS Principle)

**ID**: STRUCTURAL-022
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Requires that design and code be kept as simple and direct as possible, avoiding overly clever or complex solutions when a clear alternative exists.

## Why it matters

Unnecessary complexity is a debt that affects readability and maintainability. Simple solutions are easier to understand, test, debug, and scale, reducing error tendency and cognitive cost.

## Objective Criteria

- [ ] The **Cyclomatic Complexity Index (CC)** of any method must not exceed **5**.
- [ ] Functions and methods should perform only a single task.
- [ ] The use of metaprogramming or advanced language features is prohibited if the same result can be achieved with direct code.

## Allowed Exceptions

- **Infrastructure Libraries**: Low-level components (e.g., *parser*, *serializer*) where complexity is inherent to the task, but isolated.

## How to Detect

### Manual

Check if the code requires more than 5 seconds of analysis to understand its purpose and control flow.

### Automatic

SonarQube/ESLint: `complexity.max-cycles: 5`.

## Related to

- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): complements
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): complements
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): complements
- [021 - Prohibition of Logic Duplication](../clean-code/001_prohibition-logic-duplication.md): complements
- [026 - Comment Quality](006_comment-quality.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
