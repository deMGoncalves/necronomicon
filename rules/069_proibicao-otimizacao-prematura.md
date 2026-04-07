# Prohibition of Premature Optimization

**ID**: AP-10-069
**Severity**: 🟡 Medium
**Category**: Behavioral

---

## What It Is

Premature Optimization occurs when the developer optimizes code based on suspected slowness, without measuring the real problem. Readable and correct code is sacrificed for hypothetical performance gain. Donald Knuth: *"Premature optimization is the root of all evil."*

## Why It Matters

- Accidental complexity: code harder to read without measurable gain
- Wasted time: optimizations in code that isn't a bottleneck don't deliver value
- Introduced bugs: optimized code is more fragile and difficult to fix
- Expensive maintenance: premature optimizations are difficult to undo later

## Objective Criteria

- [ ] Optimization implemented without prior measurement (profiling, benchmark, production metrics)
- [ ] Complex algorithm where O(n²) would be imperceptible in real data volume
- [ ] Manual cache in layers that already have native caching (ORM, database, HTTP)
- [ ] Language micro-optimizations (`for` vs `map`, `++i` vs `i++`) in non-critical code
- [ ] Comment justifying illegibility with "it's faster" without evidence

## Allowed Exceptions

- **Proven Hotspots**: Optimizations in code whose slowness was identified by profiling with real production data.
- **Canonical Algorithms**: Use of known algorithms (quicksort, binary search) where the choice is industry standard, not speculative.

## How to Detect

### Manual

Ask: "is there a measurement proving this is a bottleneck?" — if the answer is no, it's premature optimization.

### Automatic

Code review: identify manual caches, unusual data structures, or micro-optimizations without referenced profiling comment.

## Related To

- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [023 - Prohibition of Speculative Functionality](023_proibicao-funcionalidade-especulativa.md): complements
- [062 - Prohibition of Clever Code](062_proibicao-codigo-inteligente-clever-code.md): reinforces
- [064 - Prohibition of Overengineering](064_proibicao-overengineering.md): complements
- [070 - Prohibition of Shared Mutable State](070_proibicao-estado-mutavel-compartilhado.md): complements

---

**Created on**: 2026-03-29
**Version**: 1.0
