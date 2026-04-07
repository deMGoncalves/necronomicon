# Maximum Lines per Method Limit

**ID**: AP-19-055
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Long Method occurs when a method has too many lines of code, typically doing many different things. Long methods are difficult to understand, test, reuse, and maintain. And they often contain multiple hidden abstractions.

## Why It Matters

- Low readability: developers lose logical flow in extensive methods
- Testing difficulty: testing multiple responsibilities in a single method is complex
- Low reusability: parts of the method cannot be reused in isolation
- Code smell: long methods often indicate SRP violation and low cohesion
- Hidden bugs: it's easy to get lost in complex control flow and introduce bugs

## Objective Criteria

- [ ] Methods with more than 20 lines of code (excluding blank lines and comments)
- [ ] Methods with more than 3 levels of nested indentation
- [ ] Methods that do more than 3 different things (e.g., validates + persists + logs)
- [ ] Methods with multiple responsibilities in sequence without clear dependency
- [ ] Methods where even the author cannot explain "what it does" in one sentence

## Allowed Exceptions

- Constructors of complex objects when there is no more readable alternative
- Methods implementing mathematical or scientific algorithms where breaking logic would reduce clarity
- Compatibility with legacy code where refactoring would bring high risk
- Event handlers or external callbacks with arbitrary third-party code

## How to Detect

### Manual
- Read methods: if you need to pause in the middle to continue understanding, it's too long
- Look for comments explaining "here it does X, now it does Y" — extraction points
- Identify methods where CTRL+F shows repeated patterns, conditions, or validations

### Automatic
- Linters: eslint (complexity, max-lines-per-function), SonarQube, CodeClimate
- Cyclomatic complexity metrics > 10 generally indicates long method
- Static analysis: detect methods with many lines and high complexity

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [007 - Maximum Lines per Class](007_limite-maximo-linhas-classe.md): complements
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): complements
- [037 - Prohibition of Flag Arguments](037_proibicao-argumentos-sinalizadores.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): complements
- [059 - Prohibition of Refused Bequest](059_proibicao-heranca-refusao.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
