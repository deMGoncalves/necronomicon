# Maximum Lines per Class File Limit

**ID**: ESTRUTURAL-007
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

Imposes a maximum limit on the number of lines of code in a class file (entity, *service*, controller), forcing the extraction of responsibilities to other classes.

*(Prevents the anti-pattern Large Class: a class with too many attributes and methods, indicating excessive responsibilities.)*

## Why It Matters

Violating the line limit is a strong indicator that the class is violating the Single Responsibility Principle (SRP), resulting in classes with low cohesion, high coupling, and extreme difficulty in maintenance and testing.

## Objective Criteria

- [ ] Class files (including declarations, methods, and properties) should have, at most, 50 lines of code (excluding blank lines and comments).
- [ ] Classes reaching 40 lines should be immediate candidates for refactoring.
- [ ] Individual methods should have, at most, 15 lines of code.

## Permitted Exceptions

- **Configuration/Initialization Classes**: Classes that only declare constants or mappings (e.g., *Mappers*, *Configuration*).
- **Test Classes**: Test *suites* where each test method is small, but the file grows due to the number of scenarios.

## How to Detect

### Manual

Visual counting or use of file metrics analysis tools.

### Automatic

SonarQube/ESLint: `max-lines-per-file: 50` and `max-lines-per-method: 5`.

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [004 - First Class Collections](004_colecoes-primeira-classe.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): reinforces
- [023 - Prohibition of Speculative Functionality](023_proibicao-funcionalidade-especulativa.md): reinforces
- [025 - Prohibition of The Blob Anti-Pattern](025_proibicao-anti-pattern-the-blob.md): reinforces
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): complements
- [055 - Maximum Lines per Method Limit](055_limite-maximo-linhas-metodo.md): complements
- [054 - Prohibition of Divergent Change](054_proibicao-mudanca-divergente.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
