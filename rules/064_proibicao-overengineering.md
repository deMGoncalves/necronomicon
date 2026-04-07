# Prohibition of Overengineering

**ID**: AP-09-064
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Overengineering occurs when a developer creates excessively complex architecture or code for simple requirements. Patterns, abstractions, layers, and frameworks introduced "for the future" that complicate code without bringing real value. Premature abstraction in the name of "scalability" or "flexibility".

*(Encompasses the Speculative Generality anti-pattern when speculative complexity is introduced at the architecture level.)*

## Why It Matters

- Cognitive overload: developers spend time understanding architecture instead of domain
- Development time: building complex features takes longer than simple solutions
- Maintenance difficulty: changes in architecture break many parts of code in cascade
- Concrete vs Abstraction imbalance: without real problems to abstract, abstractions become invented
- Honestly, simple functional requirements (REST API, CRUD) rarely justify microservices, event-driven architecture, complex DI containers

## Objective Criteria

- [ ] Introduce a pattern without clear problem being solved (e.g., Strategy pattern without variation of algorithms)
- [ ] Create interfaces/classes for "future scalability" without documented business requirements
- [ ] Multiple layers of abstraction when single layer would suffice (e.g., service calling service calling service)
- [ ] Framework usage (DI, ORM, event bus) for trivial CRUD operations
- [ ] Excess generality: generic parameterized code instead of domain-specific code

## Allowed Exceptions

- Framework code by nature general that needs to support multiple use cases
- Libraries where flexibility is primary concern (UI frameworks, ORMs)
- Explicit architectural decisions documenting why complexity is justified
- Code in extreme growth (startups with rapidly scaled MVP) where investment in architecture pays back

## How to Detect

### Manual
- Code review: ask "what concrete problem does this solve?" for each abstraction/framework introduced
- Look for "for the future" functionalities without defined timeline or requirements
- Identify code where adding simple field requires mapping config, interfaces, DTOs, services, repositories
- Check architecture: multiple layers where a single isolated layer would suffice

### Automatic
- Complexity analysis: detect abstractions with low usage frequency
- Code metrics: detect functions/classes high complexity but only 1-2 uses
- Architecture analysis: detect microservice-oriented systems where communication patterns are simple

## Related To

- [023 - Prohibition of Speculative Functionality](023_proibicao-funcionalidade-especulativa.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [010 - Single Responsibility Principle](010_principio-responsabilidade-unica.md): complements
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): reinforces
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): reinforces
- [069 - Prohibition of Premature Optimization](069_proibicao-otimizacao-prematura.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
