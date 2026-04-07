# Prohibition of Repeated Data Groupings (Data Clumps)

**ID**: AP-20-053
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Data Clumps occur when groups of data always appear together as function parameters, class attributes, or local variables, but do not have their own object or structure representing that cohesive concept. They are primitives that always travel together but have never been married.

## Why It Matters

- Parameter inflation: functions receive many individual values instead of an object
- Duplicated validation: same validation logic repeated in multiple locations
- Costly change: altering the concept requires modifying N function signatures
- Low conceptual cohesion: the domain is modeled as scattered primitives
- Difficulty extending: adding a new field requires changing all functions that use the group

## Objective Criteria

- [ ] 3 or more parameters appearing together in more than 2 different functions
- [ ] Group of attributes that are always read/written together in a class
- [ ] Removing one data element from the group renders the others meaningless or incomplete
- [ ] Same set of types/format appears repeatedly in method signatures
- [ ] Field validation is identical in different code locations

## Allowed Exceptions

- Temporary groups in one-off events or migration scripts
- Integrations with external APIs that do not allow custom objects
- Legacy code where refactoring would bring high risk without clear gain

## How to Detect

### Manual
- Search for function signatures with repeated parameters with exactly the same name/type
- Identify functions that always receive `(street, city, zipCode, country)`, `(startX, startY, endX, endY)`, `(day, month, year)`
- Look for coherence patterns: if one field changes, the others always change together

### Automatic
- Static analysis: detect signatures with identical parameter groups
- Code analysis: identify co-occurring parameters in functions
- Refactoring tools: suggestions for "Introduce Parameter Object"

## Related To

- [003 - Primitive Encapsulation](003_encapsulamento-primitivos.md): reinforces
- [033 - Maximum Parameters per Function](033_limite-parametros-funcao.md): complements
- [034 - Consistent Class and Method Names](034_nomes-classes-metodos-consistentes.md): complements
- [037 - Prohibition of Flag Arguments](037_proibicao-argumentos-sinalizadores.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
