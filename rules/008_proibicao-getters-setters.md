# Prohibition of Direct State Exposure (Getters/Setters)

**ID**: COMPORTAMENTAL-008
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Prohibits creating methods purely for direct access or modification of the object's internal state (such as `getProperty()` and `setProperty()`), reinforcing encapsulation and the "Tell, Don't Ask" principle.

## Why It Matters

Direct exposure of internal state violates encapsulation, forcing client code to decide business logic (*procedural programming*), resulting in anemic classes and coupling to implementation details.

## Objective Criteria

- [ ] Methods that return the exact value of an internal property without transformations or logic are prohibited (pure *getters*).
- [ ] Methods that only assign a value to an internal property are prohibited (pure *setters*).
- [ ] Interaction with the object should occur through methods that express business *intent* (e.g., `scheduleMeeting()` instead of `setStatus(Scheduled)`).

## Permitted Exceptions

- **Data Transfer Objects (DTOs)**: Pure classes used only for data transfer between layers, without business logic.
- **Serialization Frameworks**: Libraries that require *getters* and *setters* for mapping.

## How to Detect

### Manual

Search for methods that contain `get` or `set` prefixes followed by a property name, or methods that do not have their own business logic.

### Automatic

ESLint: Custom rules to identify empty or trivial `get/set` method patterns.

## Related To

- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): complements
- [002 - Prohibition of ELSE Clause](002_proibicao-clausula-else.md): reinforces
- [004 - First Class Collections](004_colecoes-primeira-classe.md): reinforces
- [005 - Restriction on Method Call Chaining](005_maximo-uma-chamada-por-linha.md): reinforces
- [029 - Object Immutability](029_imutabilidade-objetos-freeze.md): reinforces
- [036 - Restriction on Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
