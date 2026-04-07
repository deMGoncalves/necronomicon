# Prioritization of Simplicity and Clarity (KISS Principle)

**ID**: ESTRUTURAL-022
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Requires that design and code be kept as simple and direct as possible, avoiding excessively clever or complex solutions when a clear alternative exists.

## Why It Matters

Unnecessary complexity is a debt that affects readability and maintainability. Simple solutions are easier to understand, test, debug, and scale, reducing the tendency for errors and cognitive cost.

## Objective Criteria

- [ ] The **Cyclomatic Complexity Index (CC)** of any method should not exceed **5**.
- [ ] Functions and methods should perform only a single task.
- [ ] The use of metaprogramming or advanced language features is prohibited if the same result can be achieved with direct code.

## Permitted Exceptions

- **Infrastructure Libraries**: Low-level components (e.g., *parser*, *serializer*) where complexity is inherent to the task, but isolated.

## How to Detect

### Manual

Check if the code requires more than 5 seconds of analysis to understand its purpose and control flow.

### Automatic

SonarQube/ESLint: `complexity.max-cycles: 5`.

## Related To

- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [005 - Restriction on Method Call Chaining](005_maximo-uma-chamada-por-linha.md): complements
- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): complements
- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): complements
- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): complements
- [026 - Comment Quality](026_qualidade-comentarios-porque.md): complements
- [062 - Prohibition of Clever Code](062_proibicao-codigo-inteligente-clever-code.md): reinforces
- [064 - Prohibition of Overengineering](064_proibicao-overengineering.md): reinforces
- [068 - Prohibition of Golden Hammer](068_proibicao-martelo-de-ouro.md): reinforces
- [069 - Prohibition of Premature Optimization](069_proibicao-otimizacao-prematura.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
