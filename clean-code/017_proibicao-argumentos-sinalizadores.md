# Prohibition of Flag Arguments

**ID**: BEHAVIORAL-037
**Severity**: 🟠 High
**Category**: Behavioral

---

## What it is

Prohibits the use of boolean parameters (*boolean flags*) in function or method signatures, as they are a strong indicator that the function has more than one responsibility.

## Why it matters

Flag arguments (e.g., `process(data, shouldLog: boolean)`) violate the Single Responsibility Principle (SRP) and the Open/Closed Principle (OCP), as the function branches internally, making it difficult to test and maintain.

## Objective Criteria

- [ ] Functions must not have boolean arguments that alter the main execution path (e.g., `if (flag) { ... } else { ... }`).
- [ ] Functions with *boolean flags* must be split into separate methods, with names expressing the intent of each branch (e.g., `processAndLog(data)` and `process(data)`).
- [ ] Limit of **zero** *boolean flags* in public methods of domain classes (`Services`, `Entities`).

## Allowed Exceptions

- **System Control Modules**: Low-level functions that control *debugging* or *mode* (e.g., `isVerbose`).
- **Frameworks/Libraries**: Functions that implement a signature required by a third-party framework.

## How to Detect

### Manual

Search for function parameters typed as `boolean` or with names like `isX`, `shouldY`, `withZ`.

### Automatic

ESLint: `no-flag-args` (custom rule) or `max-params`.

## Related to

- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [011 - Open/Closed Principle](002_open-closed-principle.md): reinforces
- [033 - Maximum Parameter Limit per Function](../clean-code/013_limite-parametros-funcao.md): reinforces
- [013 - Interface Segregation Principle](004_interface-segregation-principle.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
