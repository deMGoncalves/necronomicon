# Prohibition of Divergent Change

**ID**: AP-16-054
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Divergent Change occurs when a single class is modified for multiple different and unrelated reasons. Each new type of change requires editing the same class for a completely different reason than the previous one. Complementary opposite of Shotgun Surgery: here, one class changes for N reasons.

## Why It Matters

- Violation of Single Responsibility Principle (SRP): class with multiple responsibilities
- High regression risk: changing one concern (e.g., database) can accidentally break another (e.g., business rule)
- Difficult maintenance: developers don't know which parts of the class are safe to edit
- Complex tests: it's difficult to test each responsibility in isolation when they're mixed
- Confusing commit history: commits of totally different features always touch the same file

## Objective Criteria

- [ ] Class has sections separated by comments (`// database logic`, `// business rules`, `// ui formatting`)
- [ ] Commit history shows commits of different features always modifying the same file
- [ ] Unit tests need to mock multiple responsibilities to test a single functionality
- [ ] Multiple reasons-to-change documented or discussed in code reviews
- [ ] Class continuously grows because each new feature adds +1 method for different responsibility

## Allowed Exceptions

- Small classes (< 100 lines) with closely related responsibilities
- DTOs (Data Transfer Objects) or Value Objects that by definition group data
- Adapters that need to implement multiple interfaces from the same paradigm
- Legacy code where immediate refactoring would bring unacceptable risk

## How to Detect

### Manual
- Read comments that delimit clearly distinct sections in the same class
- Analyze commit history: identify commits of different features editing the same file
- Check tests: if testing one responsibility requires preparing/mocking others, it may be divergent change
- Look for classes responsive to multiple types of requirements (database, ui, domain, infrastructure)

### Automatic
- Commit analysis: detect files with commits of multiple categories/labels
- Coupling analysis: detect classes changing for multiple reasons-to-change
- Cohesion metrics: low functional cohesion indicates multiple responsibilities

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [058 - Prohibition of Shotgun Surgery](058_proibicao-shotgun-surgery.md): complements
- [007 - Maximum Lines per Class](007_limite-maximo-linhas-classe.md): reinforces
- [025 - Prohibition of The Blob Anti-Pattern](025_proibicao-anti-pattern-the-blob.md): complements
- [004 - First-Class Collections](004_colecoes-primeira-classe.md): reinforces
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
