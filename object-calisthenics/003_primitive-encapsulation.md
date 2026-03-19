# Encapsulation of Domain Primitives (Value Objects)

**ID**: CREATIONAL-003
**Severity**: 🔴 Critical
**Category**: Creational

---

## What it is

Requires that primitive types (such as `number`, `boolean`) and the `String` class that represent domain concepts (e.g., *Email*, *CPF*, *Currency*) be encapsulated in their own immutable *Value Objects*.

## Why it matters

Ensures that validation, formatting, and business rules intrinsic to the data are defined and verified once in the constructor, avoiding inconsistencies and serious bugs from passing invalid data between methods.

## Objective Criteria

- [ ] Input parameters and return values of public methods must not be primitive/String types if they represent a specific domain concept.
- [ ] All *Value Objects* must be immutable.
- [ ] The validation logic for format and business rules of the value must be contained and executed in the *Value Object* constructor.

## Allowed Exceptions

- **Generic Primitives**: Primitive types used for counting (`i`, `index`), control booleans (`isValid`), or numbers without domain meaning (e.g., time delta).

## How to Detect

### Manual

Identify String or Number being passed as an argument in multiple methods, representing, for example, an *ID* or *Path*.

## Automatic

TypeScript: Detect excessive use of `string` or `number` for typed fields that should be dedicated classes.

## Related to

- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reinforces
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reinforces
- [024 - Prohibition of Magic Constants](../clean-code/004_prohibition-magic-constants.md): reinforces
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): reinforces
- [033 - Parameter Limit per Function](../clean-code/013_parameter-limit-per-function.md): reinforces
- [029 - Object Immutability](../clean-code/009_object-immutability.md): reinforces
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): complements
- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): complements
- [035 - Prohibition of Misleading Names](../clean-code/015_prohibition-misleading-names.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
