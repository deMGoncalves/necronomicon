# Single Level of Indentation Restriction per Method

**ID**: ESTRUTURAL-001
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Limits the complexity of a method or function by imposing a single level of indentation for code blocks (conditionals, *loops*, or *try-catch*), forcing the extraction of logic into separate methods.

## Why It Matters

Reduces Cyclomatic Complexity (CC), dramatically improving the readability and maintainability of the method, and facilitating the writing of unit tests focused on a single responsibility.

## Objective Criteria

- [ ] Methods and functions must contain, at most, a single level of code block indentation (after the initial method scope).
- [ ] The use of *guard clauses* for early returns does not count as a new level of indentation.
- [ ] Anonymous functions passed as *callbacks* should not introduce a second level of indentation in the parent method.

## Permitted Exceptions

- **Specific Control Structures**: *Try/Catch/Finally* in error handling scope that cannot be delegated.

## How to Detect

### Manual

Check for the existence of nested code blocks (e.g., an `if` inside a `for`, or a `for` inside an `if`).

### Automatic

SonarQube/ESLint: `complexity.max-depth: 1`

## Related To

- [002 - Prohibition of ELSE Clause](002_proibicao-clausula-else.md): reinforces
- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): complements
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): complements
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
