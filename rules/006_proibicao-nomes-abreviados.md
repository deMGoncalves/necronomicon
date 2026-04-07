# Prohibition of Abbreviated Names and Ambiguous Acronyms

**ID**: ESTRUTURAL-006
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Requires that names of variables, methods, classes, and parameters be complete, self-explanatory, and do not use abbreviations or acronyms that are not widely recognized in the problem domain.

## Why It Matters

Code clarity depends directly on name clarity. Abbreviations reduce readability, make code less searchable, and force developers to decode meaning, increasing cognitive cost.

## Objective Criteria

- [ ] Names of classes, methods, and variables must have, at minimum, 3 characters (except exceptions).
- [ ] Acronyms (e.g., `Mngr` for `Manager`, `Calc` for `Calculate`) are prohibited, except exceptions.
- [ ] Names should represent meaning without the need to look at documentation.

## Permitted Exceptions

- **Loop Conventions**: Unique and short-lived iteration variables (e.g., `i`, `j`).
- **Ubiquitous Acronyms**: Common industry acronyms (e.g., `ID`, `URL`, `API`, `HTTP`).

## How to Detect

### Manual

Search for variable names that are incomprehensible to a new reader without context.

### Automatic

ESLint: `naming-convention` with minimum character limits.

## Related To

- [005 - Restriction on Method Call Chaining](005_maximo-uma-chamada-por-linha.md): complements
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): reinforces
- [024 - Prohibition of Magic Constants](024_proibicao-constantes-magicas.md): complements
- [026 - Comment Quality](026_qualidade-comentarios-porque.md): reinforces
- [034 - Consistent Class and Method Names](034_nomes-classes-metodos-consistentes.md): reinforces
- [035 - Prohibition of Misleading Names](035_proibicao-nomes-enganosos.md): complements
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
