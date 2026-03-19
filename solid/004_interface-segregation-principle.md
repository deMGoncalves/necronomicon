# Application of Interface Segregation Principle (ISP)

**ID**: STRUCTURAL-013
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Requires that clients not be forced to depend on interfaces they do not use. Multiple client-specific interfaces are preferable to a single general interface.

## Why it matters

ISP violations cause anemic classes (with empty methods or throwing exceptions) and increase unnecessary coupling, as clients are forced to depend on code that will never be executed.

## Objective Criteria

- [ ] Interfaces must have at most **5** public methods.
- [ ] Classes that implement interfaces must not leave methods empty or throw "not supported" exceptions.
- [ ] If an interface is used by more than **3** different clients, it should be reviewed for segregation.

## Allowed Exceptions

- **Low-Level Interfaces**: Third-party *Framework* interfaces that require a high number of methods (e.g., `HttpRequestHandler`).

## How to Detect

### Manual

Search for interfaces with 8 or more methods, or implementing classes that leave methods without functionality.

### Automatic

SonarQube: High coupling complexity due to unused methods.

## Related to

- [010 - Single Responsibility Principle](../solid/001_single-responsibility-principle.md): reinforces
- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): complements
- [012 - Liskov Substitution Principle](../solid/003_liskov-substitution-principle.md): reinforces
- [017 - Common Reuse Principle](003_common-reuse-principle.md): complements
- [037 - Prohibition of Flag Arguments](../clean-code/017_prohibition-flag-arguments.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
