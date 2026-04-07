# Prohibition of ELSE Clause for Control Flow

**ID**: COMPORTAMENTAL-002
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Restricts the use of `else` and `else if` clauses, promoting substitution with *guard clauses* (early return) or polymorphism patterns to handle different execution paths.

## Why It Matters

Improves control flow clarity, avoids unnecessary Cyclomatic Complexity, and enforces adherence to the Single Responsibility Principle (SRP), as each code block handles a specific condition.

## Objective Criteria

- [ ] The explicit use of `else` or `else if` keywords is prohibited.
- [ ] Conditionals should be used primarily as *guard clauses* (precondition checking and return/exception throwing).
- [ ] Complex branching logic should be resolved via polymorphism (*Strategy* or *State* patterns).

## Permitted Exceptions

- **Language Control Structures**: Structures like `switch` (which generally behave like `if/else if`) can be used, as long as each `case` returns or terminates execution.

## How to Detect

### Manual

Search for ` else ` or ` else if ` in the code.

### Automatic

ESLint: `no-else-return` and `no-lonely-if` with configurations to force early exit.

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements
- [027 - Quality in Error Handling](027_qualidade-tratamento-erros-dominio.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
