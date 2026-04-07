# Encapsulation of Domain Primitives (Value Objects)

**ID**: CRIACIONAL-003
**Severity**: 🔴 Critical
**Category**: Creational

---

## What It Is

Requires that primitive types (such as `number`, `boolean`) and the `String` class representing domain concepts (e.g., *Email*, *SSN*, *Currency*) be encapsulated in their own immutable *Value Objects*.

*(Prevents the anti-pattern Primitive Obsession: use of `string`, `number`, `boolean` to represent domain concepts that should be objects with their own behavior.)*

## Why It Matters

Ensures that validation, formatting, and business rules intrinsic to the data are defined and verified once in the constructor, avoiding inconsistencies and serious bugs from passing invalid data between methods.

## Objective Criteria

- [ ] Input parameters and return values of public methods should not be primitive/String types if they represent a specific domain concept.
- [ ] All *Value Objects* must be immutable.
- [ ] Format validation logic and value business rules must be contained and executed in the *Value Object* constructor.

## Permitted Exceptions

- **Generic Primitives**: Primitive types used for counting (`i`, `index`), control booleans (`isValid`), or numbers without domain meaning (e.g., temporal delta).

## How to Detect

### Manual

Identify String or Number being passed as an argument in multiple methods, representing, for example, an *ID* or *Path*.

### Automatic

TypeScript: Detect excessive use of `string` or `number` for typed fields that should be dedicated classes.

## Related To

- [008 - Prohibition of Getters/Setters](008_proibicao-getters-setters.md): reinforces
- [009 - Tell, Don't Ask](009_diga-nao-pergunte.md): reinforces
- [024 - Prohibition of Magic Constants](024_proibicao-constantes-magicas.md): reinforces
- [006 - Prohibition of Abbreviated Names](006_proibicao-nomes-abreviados.md): reinforces
- [033 - Parameter Limit per Function](033_limite-parametros-funcao.md): reinforces
- [029 - Object Immutability](029_imutabilidade-objetos-freeze.md): reinforces
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): complements
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements
- [035 - Prohibition of Misleading Names](035_proibicao-nomes-enganosos.md): reinforces
- [053 - Prohibition of Repeated Data Clumps](053_proibicao-agrupamentos-dados-repetidos.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
