# Prohibition of The Blob Anti-Pattern (God Object)

**ID**: STRUCTURAL-025
**Severity**: 🔴 Critical
**Category**: Structural

---

## What it is

Prohibits the creation of classes that concentrate most of the system's logic and data, resulting in a **God Object** (The Blob) that other small classes only orbit and access.

## Why it matters

Severely violates the Single Responsibility Principle (SRP), resulting in the **worst form of coupling and low cohesion**. Makes the class impossible to test and the system extremely fragile to changes.

## Objective Criteria

- [ ] A class must not contain more than **10** public methods (excluding allowed *getters* and *setters*).
- [ ] The number of dependencies (imports) of concrete classes in a single class must not exceed **5**.
- [ ] If the class violates the limits of `STRUCTURAL-007` (50 lines) and `BEHAVIORAL-010` (7 methods), it should be classified as a *Blob* and refactored.

## Allowed Exceptions

- **Legacy Encapsulation**: Large classes may be accepted when encapsulating a non-OO legacy system to access it from the OO system.

## How to Detect

### Manual

Identify classes that are constantly modified by various different *feature requests*.

### Automatic

SonarQube: Very high LCOM (Lack of Cohesion in Methods) and WMC (Weighted Methods Per Class).

## Related to

- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): supersedes
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [039 - Boy Scout Rule](019_boy-scout-rule.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
