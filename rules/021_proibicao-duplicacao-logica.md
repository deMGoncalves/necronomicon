# Prohibition of Logic Duplication (DRY Principle)

**ID**: ESTRUTURAL-021
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

Requires that each piece of knowledge have a single, unambiguous, authoritative representation within the system. Prohibits duplication of logic or functionally identical code.

*(Prevents the anti-pattern Cut-and-Paste Programming: code reuse by copying instead of abstraction, creating N sources of truth that diverge over time.)*

## Why It Matters

Duplication creates severe technical debt, as a change requires modification of N other duplicated sections, exponentially increasing the risk of regression bugs and maintenance cost.

## Objective Criteria

- [ ] Direct copying of code blocks with more than **5** lines between classes or methods is prohibited.
- [ ] Complex logic used in more than **2** locations should be extracted to a reusable function or class.
- [ ] Reuse should be done via abstraction (function, class, interface) and not via *copy-paste*.

## Permitted Exceptions

- **Low-Level Configurations**: Small repetitions in configuration files or purely structural DTOs.
- **Unit Tests**: Configuration of *fixtures* or *setups* for specific test scenarios.

## How to Detect

### Manual

Search for code sections that appear identical, but have small variations (subtle duplication).

### Automatic

SonarQube/ESLint: `no-duplicated-code` (with semantic analysis).

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements
- [040 - Single Codebase](040_base-codigo-unica.md): complements
- [058 - Prohibition of Shotgun Surgery](058_proibicao-shotgun-surgery.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
