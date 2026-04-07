# Prohibition of Zombie Code (Lava Flow)

**ID**: AP-02-056
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Lava Flow (Dead Code / Zombie Code) occurs when code is no longer used but remains in the system because no one is sure if it can be safely removed. Like lava that solidifies and hardens, this code becomes a permanent obstacle to maintenance. Abandoned, commented, or never-called code.

## Why It Matters

- Extra cognitive load: developers need to understand useless code to find useful code
- Perpetuated confusion: new developers don't know what's active or obsolete
- Growing technical debt: the system becomes larger and slower to navigate
- Preserved bugs: dead code can be accidentally reactivated and introduce old bugs
- False complexity: system appears to do more than it actually does

## Objective Criteria

- [ ] Functions, classes, or modules never called/executed
- [ ] Commented code with markers like `// old version`, `// deprecated`, `// TODO remove`
- [ ] Imports of modules/packages that are never referenced
- [ ] `if` or `switch` branches that are never executed (test coverage = 0%)
- [ ] Variables declared and never read
- [ ] Entire files that no one knows what they're for

## Allowed Exceptions

- Temporarily disabled/commented code with well-documented @TODO and deadline
- Feature flags or A/B tests with known usage
- Code maintained for immediate rollback (< 1 day) when there's critical functionality
- Historical documentation maintained in comments when it has educational value

## How to Detect

### Manual
- Search for comments with `//`, `#` prefixes and TODO, FIXME, DEPRECATED
- Look for files with "If __name__ == '__main__'" but no real usage
- Identify functions/classes without unit tests, without imports, without references
- Check imported but never used modules

### Automatic
- Static analysis: dead code detection (pyflakes, eslint no-unused-vars, unused-import)
- Code coverage: branches/lines with 0% coverage are suspect
- Tree shaking tools to detect unreferenced code in frontend
- IDE tools: "Find Unused Code" in VS Code, PyCharm

## Related To

- [039 - Boy Scout Rule (Continuous Refactoring)](039_regra-escoteiro-refatoracao-continua.md): reinforces
- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): complements
- [025 - Prohibition of The Blob Anti-Pattern](025_proibicao-anti-pattern-the-blob.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [032 - Minimum Test Coverage and Quality](032_cobertura-teste-minima-qualidade.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
