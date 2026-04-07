# Prohibition of Spaghetti Code

**ID**: AP-03-060
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

Spaghetti Code occurs when the code's control flow is complex and intertwined like a plate of spaghetti. Multiple branches, deeply nested loops, `goto`s (or equivalents), and intertwined control logic. It's difficult to follow the execution flow from end to end.

## Why It Matters

- Impossible to understand: developers cannot track logical flow
- Hidden bugs: complex control flow hides edge cases and untested conditions
- Difficult to test: branch coverage becomes nightmare; there are hundreds of paths
- Difficult to maintain: changes break non-obvious paths; unknown side effects
- Difficult to refactor: any change can break intertwined flow
- Very high onboarding cost: new developers take months to effectively understand the code

## Objective Criteria

- [ ] More than 3 levels of nested indentation (if inside if inside if)
- [ ] Branches that jump arbitrarily to different parts of code (goto equivalents)
- [ ] Functions with unexpected external state mutation (global variables, shared mutable state)
- [ ] Control flow that depends on variables mutated in multiple distant locations
- [ ] Multiple entry/exit points in same function (early returns everywhere, loops with mixed break/continue)
- [ ] Cyclomatic complexity > 15 in same function

## Allowed Exceptions

- State machines implemented with well-documented switch/case
- Event driven code single dispatcher with multiple handlers (cleaner pattern than goto)
- Protocol parsers or network code necessarily complex by external specification
- Legacy code where immediate refactoring would bring unacceptable risk

## How to Detect

### Manual
- Read code: if you visualize flow as graph with edges crossing everywhere, it's spaghetti
- Look for variables mutated in multiple locations without clear locality
- Identify functions where there are multiple chained `if/else` with nested branches
- Check for early returns, breaks, continues mixed in loops and modules

### Automatic
- Cyclomatic complexity analysis: complexity > 15 indicates risk
- Code visualization: generate call graphs and detect intertwined control flow
- Static analysis: detect global variable usage, mutability issues
- Linters: max-depth, max-params, no-eqeqeq (for comparisons leading to spaghetti)

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [055 - Maximum Lines per Method](055_limite-maximo-linhas-metodo.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [066 - Prohibition of Pyramid of Doom](066_proibicao-piramide-do-destino.md): complements
- [037 - Prohibition of Flag Arguments](037_proibicao-argumentos-sinalizadores.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
