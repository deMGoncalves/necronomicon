# Prohibition of Pyramid of Doom

**ID**: AP-23-066
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Pyramid of Doom (or Arrow Anti-Pattern) occurs when there's excessive nesting of conditionals (`if`/`else`) and loops that creates a visual pyramid or arrow structure. Each nesting level adds cognitive complexity and increases Cyclomatic Complexity Index. The happy path is buried deep inside instead of level zero. Synchronous version of Callback Hell.

## Why It Matters

- Non-linear reading: developers can't follow top-to-bottom flow; need to track nesting
- Bugs in edge cases: nested paths rarely tested; bugs frequently found in deep levels
- Difficulty adding conditions: each new validation increases nesting; refactoring requires reindentation
- Complexity inflation: simple validations transform into complex structures with nested ifs
- High Cyclomatic Complexity: each level doubles the number of possible execution paths

## Objective Criteria

- [ ] Code with 4+ levels of if/else/loops nesting
- [ ] `if` inside `if` inside `for` inside `if` — visual pyramid pattern
- [ ] Cyclomatic Complexity > 10 in same function
- [ ] Happy path is at nesting level 3+ instead of level zero
- [ ] Multiple `else` statements without early return/guard clauses

## Allowed Exceptions

- Legacy code where immediate refactoring would bring high risk without clear gain
- Parser code or state machines necessarily complex by external specification
- Event handlers where multiple validations are mandatory and cannot be extracted

## How to Detect

### Manual
- Visual scan: look for code with arrow shape with nesting
- Look for code where adding new validation requires reindenting everything below
- Identify functions where never do early return; all paths nested in else

### Automatic
- Linters: detect nesting depth > 3, cyclomatic complexity > 10
- Code formatters: auto-format that visualizes pyramids via excessive indentation
- Static analysis: Cyclomatic Complexity metrics, nesting depth analysis

## Related To

- [002 - Prohibition of Else Clause](002_proibicao-clausula-else.md): reinforces
- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [060 - Prohibition of Spaghetti Code](060_proibicao-codigo-spaghetti.md): complements
- [063 - Prohibition of Callback Hell](063_proibicao-inferno-callbacks.md): complements
- [027 - Domain Error Handling Quality](027_qualidade-tratamento-erros-dominio.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
