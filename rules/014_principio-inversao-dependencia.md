# Application of the Dependency Inversion Principle (DIP)

**ID**: COMPORTAMENTAL-014
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

High-level modules should not depend on low-level modules. Both should depend on abstractions (interfaces).

## Why It Matters

DIP is crucial for decoupling business policy from implementation. Violation creates tight coupling, making tests (unit and integration) difficult and preventing the high-level module from being reused in a new context.

## Objective Criteria

- [ ] Creating new instances of concrete classes (*new Class()*) is prohibited inside high-level classes (e.g., *Services* and *Controllers*).
- [ ] High-level modules should reference only interfaces or abstract classes (what will be injected).
- [ ] The number of *imports* for concrete classes in constructors should be zero (only injection of abstractions).

## Permitted Exceptions

- **Entities and Value Objects**: Pure data classes that can be instantiated freely.
- **Root Composer**: The system initialization module where dependency injection is configured.

## How to Detect

### Manual

Search for `new ConcreteName()` inside *Services* or *Business Logic* code.

### Automatic

ESLint: `no-new-without-abstraction` (with custom rules).

## Related To

- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): reinforces
- [015 - Release Reuse Equivalency Principle](015_principio-equivalencia-lancamento-reuso.md): reinforces
- [003 - Encapsulation of Primitives](003_encapsulamento-primitivos.md): complements
- [018 - Acyclic Dependencies Principle](018_principio-dependencias-aciclicas.md): reinforces
- [019 - Stable Dependencies Principle](019_principio-dependencias-estaveis.md): reinforces
- [020 - Stable Abstractions Principle](020_principio-abstracoes-estaveis.md): reinforces
- [032 - Minimum Test Coverage](032_cobertura-teste-minima-qualidade.md): complements
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): complements
- [043 - Backing Services as Resources](043_servicos-apoio-recursos.md): complements

---

**Created on**: 2025-10-04
**Updated on**: 2025-10-04
**Version**: 1.1
