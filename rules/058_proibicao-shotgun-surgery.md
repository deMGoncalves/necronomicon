# Prohibition of Shotgun Surgery

**ID**: AP-15-058
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Shotgun Surgery occurs when a single change requires altering multiple different classes or modules. Complementary opposite of Divergent Change: here, each new requirement requires making changes in multiple code locations (like firing a shotgun, hitting several points). Indicates low cohesion and high coupling.

## Why It Matters

- Costly changes: each new requirement or fix requires touching N places
- High regression probability: it's easy to forget one of the N locations that need to change
- Testing difficulty: testing spread changes requires creating mocks for multiple modules
- Indication of replicated code: logic that should be centralized is duplicated
- Fragile: when changing a requirement, it breaks something in the other N previously affected modules

## Objective Criteria

- [ ] Behavior change requires altering 3+ classes/modules
- [ ] Same calculation or validation logic exists in multiple locations
- [ ] Adding new field/feature requires modifying N files in different layers
- [ ] Bug fix needs to be applied to multiple files with same correction pattern
- [ ] Code review shows commits modifying completely different files without clear relationship

## Allowed Exceptions

- Explicit architectures where layers are intentionally separated (controller, service, repository)
- Plugins/modular systems where opinions are extensible by design
- Legacy code where immediate refactoring would bring unacceptable risk
- Microservices boundaries by design where multiple services handle same domain concern

## How to Detect

### Manual
- Analyze commit history: feature commits that always touch N different files
- Look for duplicated behaviors: same logic in controllers, services, repositories
- Check new feature addition: would it require changing configuration, schema, multiple handlers, tests in multiple files?
- Code review: developers say "I need to change X, Y, Z and W" for a single feature

### Automatic
- Commit analysis: detect commits that always touch multiple different files for same feature
- Code similarity analysis: detect duplicated or very similar code in multiple locations
- Cohesion analysis: low cohesion between modules indicates shotgun surgery

## Related To

- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): reinforces
- [054 - Prohibition of Divergent Change](054_proibicao-mudanca-divergente.md): complements
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): complements
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): reinforces
- [017 - Common Reuse Principle](017_principio-reuso-comum.md): reinforces
- [039 - Boy Scout Rule (Continuous Refactoring)](039_regra-escoteiro-refatoracao-continua.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
