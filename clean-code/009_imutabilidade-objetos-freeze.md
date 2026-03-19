# Domain Object Immutability (Object.freeze)

**ID**: CREATIONAL-029
**Severity**: 🟠 High
**Category**: Creational

---

## What it is

Requires that all objects created to represent Domain Entities or *Value Objects* be **immutable**, explicitly applying freezing methods (`Object.freeze()`) before being exposed.

## Why it matters

Accidental mutability introduces severe bugs and makes it difficult to track the origin of state changes, violating the **Encapsulation** principle. Freezing ensures that the object does not change after its creation.

## Objective Criteria

- [ ] All instances of `Value Objects` or domain `Entities` must be frozen before leaving the constructor or persistence layer.
- [ ] Accepting domain objects as parameters in public methods and modifying them without cloning or forcing an intent method is prohibited.
- [ ] Immutability must be applied in a *shallow* or *deep* manner, depending on the object.

## Allowed Exceptions

- **Pure DTOs**: Data transfer objects used strictly for external communication or data mapping.

## How to Detect

### Manual

Check for absence of `Object.freeze()` in *Factory* methods or Entity constructors.

### Automatic

TypeScript: Use of `readonly` on properties.

## Related to

- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [036 - Side Effects Function Restriction](../clean-code/016_restricao-funcoes-efeitos-colaterais.md): reinforces
- [045 - Stateless Processes](../twelve-factor/006_processos-stateless.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
