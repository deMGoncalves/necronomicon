# Domain Objects Immutability (Object.freeze)

**ID**: CRIACIONAL-029
**Severity**: 🟠 High
**Category**: Creational

---

## What It Is

Requires that all objects created to represent Domain Entities or *Value Objects* be **immutable**, explicitly applying freezing methods (`Object.freeze()`) before being exposed.

## Why It Matters

Accidental mutability introduces severe bugs and makes tracking the origin of state changes difficult, violating the **Encapsulation** principle. Freezing ensures the object does not change after its creation.

## Objective Criteria

- [ ] All instances of `Value Objects` or domain `Entities` must be frozen before leaving the constructor or persistence layer.
- [ ] Accepting domain objects as parameter in public methods and modifying them without cloning or enforcing an intent method is prohibited.
- [ ] Immutability must be applied in *shallow* (superficial) or *deep* (profound) form, depending on the object.

## Allowed Exceptions

- **Pure DTOs**: Data transfer objects used strictly for external communication or data mapping.

## How to Detect

### Manual

Check for absence of `Object.freeze()` in *Factory* methods or Entity constructors.

### Automatic

TypeScript: Use of `readonly` on properties.

## Related To

- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [045 - Stateless Processes](045_processos-stateless.md): complements
- [070 - Prohibition of Shared Mutable State](070_proibicao-estado-mutavel-compartilhado.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
