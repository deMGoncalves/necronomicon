# Prohibition of Clever Code

**ID**: AP-04-062
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What It Is

Clever Code occurs when a developer writes excessively concise code, using non-obvious tricks, complex operators, or unconventional code patterns to show "skill" instead of prioritizing clarity. Code that makes the developer feel smart when writing (and others feel confused when reading).

## Why It Matters

- Maintenance difficulty: other developers don't understand code without spending much time
- Hides bugs: complex code has more edge cases and is harder to reason about
- Frustrates team: creates culture of "code cleverness" over code clarity
- Onboarding difficulty: new developers take much longer to be productive
- Common in code reviews: "this works but I can't understand it"

## Objective Criteria

- [ ] Code review comments asking "what does this do?" or "can it be clearer?"
- [ ] Use of complex one-liners: ternary chaining, arrow functions with multiple operations
- [ ] Bit-shifting operators, bitwise manipulations, or other advanced language features without clarifying comments
- [ ] Complex regex or string parsing embedded in main code
- [ ] Functions with short non-explanatory names (`fn()`, `go()`, `proc()`) doing complex logic

## Allowed Exceptions

- Optimized copy of known algorithms (CRC32, MD5) where purpose is clear via function name
- Code golfing in intentionally tiny functions where context makes meaning obvious
- Performance-critical paths that were profiled as hotspots where comments justify optimization
- Specific domain (crypto, graphics, systems programming) where standard operations are known

## How to Detect

### Manual
- Code review: explicit rules to reject code "clever" over code "clear"
- Look for one-liners with > 3 operations on same lines
- Identify code that developer spends 5 minutes reading without being author
- Check comments pointing "this is an optimization" without profiling measurements

### Automatic
- Linters: ESLint (no-nested-ternary, max-depth, complexity), SonarQube simplicity rules
- Auto-formatters: prettier, black force more readable style
- Cyclomatic complexity: detect functions with high complexity that can be written more simply

## Related To

- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [034 - Consistent Class and Method Names](034_nomes-classes-metodos-consistentes.md): reinforces
- [033 - Maximum Parameters per Function](033_limite-parametros-funcao.md): reinforces
- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [069 - Prohibition of Premature Optimization](069_proibicao-otimizacao-prematura.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
