# Prohibition of Callback Hell

**ID**: AP-05-063
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Callback Hell occurs when asynchronous code is written using deep callback nesting, creating difficult-to-follow control flow. Multiple nested callbacks create arrow-shaped code with indentation progressing to the right, making code almost impossible to read and maintain.

## Why It Matters

- Reading difficulty: developers lose track of levels; don't know in which callback they are
- Difficult to debug errors: error handling spread across multiple levels
- Testing difficulty: testing each callback in isolation is impossible
- Common errors: forgetting to call next callback, proper error handling, or return early
- Specific problem of languages/paradigms without async/await or promises

## Objective Criteria

- [ ] More than 3 levels of callback nesting
- [ ] Callback functions defined inline instead of named functions
- [ ] Error handling repeated at each callback level (try/catch inside each callback)
- [ ] `}) })` pattern at end of file — markers of callback hell
- [ ] Variables captured in closures of multiple levels, creating hard-to-reason-about state

## Allowed Exceptions

- Legacy code where language/runtimes don't support promises or async/await
- External APIs that strictly require callback pattern without alternative
- Single-level callback nesting with simple logic (only one async operation)

## How to Detect

### Manual
- Visual scan: look for code with right-drifting indentation multi-level callbacks
- Look for `} })` pattern at end of functions with many callbacks
- Identify functions passing callbacks that in turn pass callbacks
- Check stack traces when debugging: deeply nested stack frames with callback functions

### Automatic
- Linters: detect callback nesting depth > threshold
- Code metrics: calculate cyclomatic complexity in function with callbacks
- Code quality tools: detect callback hell anti-pattern specific to JS/Python

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [028 - Asynchronous Exception Handling](028_tratamento-excecao-assincrona.md): reinforces
- [060 - Prohibition of Spaghetti Code](060_proibicao-codigo-spaghetti.md): reinforces
- [027 - Domain Error Handling Quality](027_qualidade-tratamento-erros-dominio.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
