# Prohibition of Golden Hammer

**ID**: AP-06-068
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Golden Hammer occurs when a developer or team applies the same tool, pattern, or technology to all problems, regardless of appropriateness. Like the saying "for a man with a hammer, everything looks like a nail", this defines the bias of using the same universal solution (the golden hammer) in all contexts.

## Why It Matters

- Suboptimal solutions: using wrong tool for specific problem, creating over-engineering or under-engineering
- Evolution difficulty: when problem changes, still using same "golden hammer" even if inadequate
- Mental innovation lack: team stops learning new tools; clings to known content
- Technical debt accumulates: universal solutions are often complex when applied where simple helps
- Frustrates technical team: experienced developers see wrong tools being used

## Objective Criteria

- [ ] Same tool/pattern applied in 3+ significantly different contexts
- [ ] Rejection of alternatives with "we always use X" without justification
- [ ] Use of microservice pattern in systems where single monolith would suffice
- [ ] Use of NoSQL database in strongly relational systems or vice versa
- [ ] Framework/library event-bus in systems with simple synchronous operation

## Allowed Exceptions

- Standard enforced patterns by compliance/regulation (e.g., security frameworks)
- Company-wide technology stack where variance would bring greater maintainability cost
- Known and battle-tested libraries/frameworks where investing in new technology risk is high

## How to Detect

### Manual
- Code review: question "is this the best tool for this problem?" for each technology choice
- Look for repeated patterns in different domains: same ORM used for KV store, search engine, relational DB
- Identify architectures where every feature even small uses same complex pattern (event bus for everything, microservice for everything)

### Automatic
- Architecture analysis: detect patterns applied across multiple domains when domain characteristics differ
- Code complexity: detect framework overhead where simple solution would exist

## Related To

- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): reinforces
- [064 - Prohibition of Overengineering](064_proibicao-overengineering.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): reinforces
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): complements

---

**Created on**: 2026-03-28
**Version**: 1.0
