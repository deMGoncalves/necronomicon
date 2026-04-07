# Prohibition of The Blob Anti-Pattern (God Object)

**ID**: ESTRUTURAL-025
**Severity**: 🔴 Critical
**Category**: Structural

---

## What It Is

Prohibits the creation of classes that concentrate most of the system's logic and data, resulting in a **God Object** (The Blob) that other small classes merely orbit and access.

*(The anti-pattern Large Class is the initial stage of a Blob: Large Class violates SRP due to too many responsibilities; The Blob adds the domain of centralized data that other classes merely orbit.)*

## Why It Matters

Severely violates the Single Responsibility Principle (SRP), resulting in the **worst form of coupling and low cohesion**. Makes the class impossible to test and the system extremely fragile to changes.

## Objective Criteria

- [ ] A class should not contain more than **10** public methods (excluding permitted *getters* and *setters*).
- [ ] The number of dependencies (imports) of concrete classes in a single class should not exceed **5**.
- [ ] If the class violates the limits of `ESTRUTURAL-007` (50 lines) and `COMPORTAMENTAL-010` (7 methods), it should be classified as a *Blob* and refactored.

## Permitted Exceptions

- **Legacy Encapsulation**: Large classes may be accepted when encapsulating a non-OO legacy system to access it from the OO system.

## How to Detect

### Manual

Identify classes that are constantly being modified by several different *feature requests*.

### Automatic

SonarQube: Very high LCOM (Lack of Cohesion in Methods) and WMC (Weighted Methods Per Class).

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): replaces
- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [039 - Boy Scout Rule](039_regra-escoteiro-refatoracao-continua.md): complements
- [056 - Prohibition of Zombie Code (Lava Flow)](056_proibicao-codigo-zombie-lava-flow.md): reinforces
- [054 - Prohibition of Divergent Change](054_proibicao-mudanca-divergente.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
