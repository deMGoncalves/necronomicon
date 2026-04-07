# Common Closure Principle (CCP)

**ID**: ESTRUTURAL-016
**Severity**: 🟠 High
**Category**: Structural

---

## What It Is

Classes that change together for the same reason should be packaged together.

## Why It Matters

CCP reinforces SRP at the package level, ensuring that software modifications are localized. It reduces the need to change many packages in a single requirement change, facilitating deployment and maintenance.

## Objective Criteria

- [ ] The package should be reviewed if a requirement change causes modifications in more than **3** unrelated class/module files.
- [ ] Classes related to a single domain entity (e.g., `Order`, `OrderService`, `OrderFactory`) should be in the same package.
- [ ] Classes that change together should be located in the same directory to facilitate cohesion.

## Permitted Exceptions

- **Shared Infrastructure Classes**: Classes that are used in many packages and live in a low-level utility package.

## How to Detect

### Manual

Analyze commit history: check if a single *feature request* affected classes spread across multiple packages.

### Automatic

Code metrics analysis: tools that track files changed per functionality.

## Related To

- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): reinforces
- [015 - Release Reuse Equivalency Principle](015_principio-equivalencia-lancamento-reuso.md): complements
- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [017 - Common Reuse Principle](017_principio-reuso-comum.md): complements
- [058 - Prohibition of Shotgun Surgery](058_proibicao-shotgun-surgery.md): reinforces
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
