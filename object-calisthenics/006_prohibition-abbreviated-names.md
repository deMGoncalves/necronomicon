# Prohibition of Abbreviated Names and Ambiguous Acronyms

**ID**: STRUCTURAL-006
**Severity**: 🟡 Medium
**Category**: Structural

---

## What it is

Requires that names of variables, methods, classes, and parameters be complete, self-explanatory, and not use abbreviations or acronyms that are not widely recognized in the problem domain.

## Why it matters

Code clarity depends directly on name clarity. Abbreviations reduce readability, make code less searchable, and force developers to decode meaning, increasing cognitive cost.

## Objective Criteria

- [ ] Names of classes, methods, and variables must have at least 3 characters (except exceptions).
- [ ] Acronyms (e.g., `Mngr` for `Manager`, `Calc` for `Calculate`) are prohibited, except exceptions.
- [ ] Names must represent meaning without needing to look at documentation.

## Allowed Exceptions

- **Loop Conventions**: Single, short-lived iteration variables (e.g., `i`, `j`).
- **Ubiquitous Acronyms**: Industry-common acronyms (e.g., `ID`, `URL`, `API`, `HTTP`).

## How to Detect

### Manual

Search for variable names that are incomprehensible to a new reader without context.

### Automatic

ESLint: `naming-convention` with minimum character limits.

## Related to

- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): complements
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): reinforces
- [024 - Prohibition of Magic Constants](../clean-code/004_prohibition-magic-constants.md): complements
- [026 - Comment Quality](../clean-code/006_comment-quality.md): reinforces
- [034 - Consistent Class and Method Names](../clean-code/014_consistent-class-method-names.md): reinforces
- [035 - Prohibition of Misleading Names](../clean-code/015_prohibition-misleading-names.md): complements
- [022 - Prioritization of Simplicity and Clarity](../clean-code/002_prioritization-simplicity-clarity.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
