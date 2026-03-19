# Common Closure Principle (CCP)

**ID**: STRUCTURAL-016
**Severity**: 🟠 High
**Category**: Structural

---

## What it is

Classes that change together for the same reason should be packaged together.

## Why it matters

CCP reinforces SRP at the package level, ensuring that software modifications are localized. It reduces the need to change many packages in a single requirement change, facilitating deployment and maintenance.

## Objective Criteria

- [ ] The package should be reviewed if a requirement change causes modifications in more than **3** unrelated class/module files.
- [ ] Classes related to a single domain entity (e.g., `Order`, `OrderService`, `OrderFactory`) should be in the same package.
- [ ] Classes that change together should be located in the same directory to facilitate cohesion.

## Allowed Exceptions

- **Shared Infrastructure Classes**: Classes that are used in many packages and live in a low-level utility package.

## How to Detect

### Manual

Analyze commit history: check if a single *feature request* affected classes scattered across several packages.

### Automatic

Code metrics analysis: tools that track files changed per functionality.

## Related to

- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reinforces
- [015 - Release Reuse Equivalency Principle](../package-principles/001_release-reuse-equivalency-principle.md): complements
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reinforces
- [017 - Common Reuse Principle](../package-principles/003_common-reuse-principle.md): complements

---

**Created on**: 2025-10-04
**Version**: 1.0
