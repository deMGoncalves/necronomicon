# Prohibition of Flag Arguments

**ID**: COMPORTAMENTAL-037
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Prohibits using boolean parameters (*boolean flags*) in function or method signatures, as they are a strong indicator that the function has more than one responsibility.

## Why It Matters

Flag arguments (e.g., `process(data, shouldLog: boolean)`) violate the Single Responsibility Principle (SRP) and the Open/Closed Principle (OCP), as the function branches internally, making it difficult to test and maintain.

## Objective Criteria

- [ ] Functions must not have boolean arguments that alter the main execution path (e.g., `if (flag) { ... } else { ... }`).
- [ ] Functions with *boolean flags* must be split into separate methods with names expressing each branch's intent (e.g., `processAndLog(data)` and `process(data)`).
- [ ] Limit of **zero** *boolean flags* in public methods of domain classes (`Services`, `Entities`).

## Allowed Exceptions

- **System Control Modules**: Low-level functions that control *debugging* or *mode* (e.g., `isVerbose`).
- **Frameworks/Libraries**: Functions that implement a signature required by a third-party framework.

## How to Detect

### Manual

Search for function parameters typed as `boolean` or with names like `isX`, `shouldY`, `withZ`.

### Automatic

ESLint: `no-flag-args` (custom rule) or `max-params`.

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces
- [033 - Parameter Limit per Function](033_limite-parametros-funcao.md): reinforces
- [013 - Interface Segregation Principle](013_principio-segregacao-interfaces.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
