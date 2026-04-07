# Application of the Interface Segregation Principle (ISP)

**ID**: ESTRUTURAL-013
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Requires that clients not be forced to depend on interfaces they do not use. Multiple client-specific interfaces are preferable to a single general interface.

## Why It Matters

ISP violations cause anemic classes (with empty methods or throwing exceptions) and increase unnecessary coupling, as clients are forced to depend on code that will never be executed.

## Objective Criteria

- [ ] Interfaces should have, at most, **5** public methods.
- [ ] Classes implementing interfaces should not leave methods empty or throw "not supported" exceptions.
- [ ] If an interface is used by more than **3** different clients, it should be reviewed for segregation.

## Permitted Exceptions

- **Low-Level Interfaces**: Third-party *Framework* interfaces that require a high number of methods (e.g., `HttpRequestHandler`).

## How to Detect

### Manual

Search for interfaces with 8 or more methods, or implementing classes that leave methods without functionality.

### Automatic

SonarQube: High coupled complexity due to unused methods.

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): complements
- [012 - Liskov Substitution Principle](012_principio-substituicao-liskov.md): reinforces
- [017 - Common Reuse Principle](017_principio-reuso-comum.md): complements
- [037 - Prohibition of Flag Arguments](037_proibicao-argumentos-sinalizadores.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
