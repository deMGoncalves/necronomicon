# Application of the "Tell, Don't Ask" Principle (Law of Demeter)

**ID**: COMPORTAMENTAL-009
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Requires that a method call methods or access properties only of its "immediate neighbors": the object itself, objects passed as arguments, objects it creates, or objects that are direct internal properties.

*(Prevents the anti-pattern Message Chains / Train Wreck: by telling the object what to do instead of navigating its internal structure via chained getters.)*

## Why It Matters

Violations of the Law of Demeter result in high and transitive coupling (*train wrecks*), making code fragile to internal changes in objects distant in the dependency chain, and obscuring the responsibility of each object.

## Objective Criteria

- [ ] A method should avoid calling methods of an object returned by another method (e.g., `a.getB().getC().f()`).
- [ ] Method calls should be restricted to objects that the method has direct knowledge of.
- [ ] The client object should *tell* the dependent object what to do, instead of *asking* for internal state to make a decision.

## Permitted Exceptions

- **Fluent Interface Patterns (Chaining)**: As long as the method returns `this` (or the same interface), as in Builders.
- **Access to DTOs/Value Objects**: Data access from objects that are purely data containers.

## How to Detect

### Manual

Search for call chaining (*dot-chaining*) with three or more consecutive calls, indicating knowledge of nested objects.

### Automatic

ESLint: `no-chaining` with high depth and `no-access-target` (with custom plugins).

## Related To

- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [005 - Restriction on Method Call Chaining](005_maximo-uma-chamada-por-linha.md): reinforces
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): reinforces
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): reinforces
- [004 - First Class Collections](004_colecoes-primeira-classe.md): complements
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): reinforces
- [036 - Restriction on Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [038 - Command-Query Separation Principle](038_conformidade-principio-inversao-consulta.md): reinforces
- [057 - Prohibition of Feature Envy](057_proibicao-feature-envy.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
