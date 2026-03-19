# Maximum Parameter Limit per Function

**ID**: STRUCTURAL-033
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Defines a maximum limit of **3 parameters** per function or method to reduce signature complexity and enforce cohesion, promoting the use of *Parameter Objects* (DTOs).

## Why it matters

Functions with many parameters (*Long Parameter List*) increase **cognitive complexity**, hinder testability, and often indicate a violation of the Single Responsibility Principle (SRP).

## Objective Criteria

- [ ] Functions and methods must not have more than **3** parameters.
- [ ] For more than 3 parameters, a parameter object (DTO or *Value Object*) must be created to group the data.
- [ ] Class constructors may exceed the limit if they are setting up an object via dependency injection.

## Allowed Exceptions

- **External Library Functions**: Functions that implement a signature required by a *framework* or third-party library.

## How to Detect

### Manual

Identify method signatures with 4 or more parameters.

### Automatic

Biome/ESLint: `max-params: ["error", 3]`.

## Related to

- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [037 - Prohibition of Flag Arguments](../clean-code/017_proibicao-argumentos-sinalizadores.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
