---
name: package-principles
description: "6 package design principles (Robert C. Martin). Use when @architect organizes modules/packages, or @reviewer checks compliance with rules 015-020 in imports and dependencies."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Package Principles (Robert C. Martin)

## What It Is

The **6 Package Principles** by Robert C. Martin are metrics and guidelines for organizing classes into cohesive packages/modules with healthy dependencies. Divided into two complementary groups:

### Group 1: Package Cohesion (Principles of Package Cohesion)
Answer: **"What to put inside a package?"**

- **REP** (Release Reuse Equivalency): Reuse granularity = release granularity
- **CCP** (Common Closure): Classes that change together should be together
- **CRP** (Common Reuse): Classes reused together should be together

### Group 2: Package Coupling (Principles of Package Coupling)
Answer: **"How to organize dependencies between packages?"**

- **ADP** (Acyclic Dependencies): Dependency graph must be acyclic (DAG)
- **SDP** (Stable Dependencies): Depend on stable packages
- **SAP** (Stable Abstractions): Stable packages should be abstract

## When to Use

| Scenario | Relevant Principle(s) |
|----------|-----------------------|
| Create new module/package | REP, CCP, CRP (Cohesion) |
| Organize folder structure | CCP, CRP |
| Decide where to place a class | CCP (changes with which others?) |
| Version shared library | REP |
| Detect circular import | ADP |
| Assess module stability | SDP, SAP |
| Refactor to reduce coupling | ADP, SDP |
| Define module public interface | SAP, CRP |

## The 6 Principles

| Principle | Group | deMGoncalves Rule | Key Question | Reference File |
|-----------|-------|-------------------|--------------|----------------|
| **REP** - Release Reuse Equivalency | Cohesion | [015](../../rules/015_principio-equivalencia-lancamento-reuso.md) | Do reuse and release have same granularity? | [rep.md](references/rep.md) |
| **CCP** - Common Closure | Cohesion | [016](../../rules/016_principio-fechamento-comum.md) | Are classes that change together together? | [ccp.md](references/ccp.md) |
| **CRP** - Common Reuse | Cohesion | [017](../../rules/017_principio-reuso-comum.md) | If you use one class, do you use all in package? | [crp.md](references/crp.md) |
| **ADP** - Acyclic Dependencies | Coupling | [018](../../rules/018_principio-dependencias-aciclicas.md) | Is dependency graph DAG? | [adp.md](references/adp.md) |
| **SDP** - Stable Dependencies | Coupling | [019](../../rules/019_principio-dependencias-estaveis.md) | Instability I < 0.5 for critical modules? | [sdp.md](references/sdp.md) |
| **SAP** - Stable Abstractions | Coupling | [020](../../rules/020_principio-abstracoes-estaveis.md) | High Abstraction A if low Instability I? | [sap.md](references/sap.md) |

## Architectural Tension: Cohesion Triangle

The three cohesion principles create **architectural tension**:

```
          REP
         /   \
        /     \
       /       \
      /         \
     /           \
    CCP --------- CRP
```

- **REP ↔ CCP**: CCP favors cohesion by change (large classes). REP favors granular reuse (small packages).
- **CCP ↔ CRP**: CCP wants everything together that changes together. CRP wants to separate what's not reused together.
- **REP ↔ CRP**: REP wants cohesive releases. CRP wants independently reusable packages.

**Balance**: Architect must find equilibrium according to project phase (early stage = CCP; mature = REP + CRP).

## Quick Selection by Symptom

### "Small commit affects 10+ files in different packages"
→ **CCP violation** — classes that change together should be together

### "Updating library requires accepting 50 unused classes"
→ **CRP violation** — package has classes not reused together

### "Circular import between modules breaks build"
→ **ADP violation** — break cycle via DIP (extract interface)

### "Domain module depends on volatile infra module"
→ **SDP violation** — dependencies should point to stability

### "Stable module but 100% concrete (zero interfaces)"
→ **SAP violation** — stable packages should be abstract

### "Don't know where to place new class"
→ **Apply CCP** — place with classes that will change for same reason

## Prohibitions

This skill detects and prevents:

- **❌ Circular dependencies** (violates ADP)
- **❌ Packages with heterogeneous classes** (violates CCP, CRP)
- **❌ Stable module depending on unstable** (violates SDP)
- **❌ Stable module 100% concrete** (violates SAP)
- **❌ Releases with different granularity than reuse** (violates REP)
- **❌ Commit touching multiple unrelated packages** (violates CCP)

## Objective Metrics

### Instability (I)
```
I = Outgoing Dependencies / Total Dependencies
I ∈ [0, 1]

I = 0 → Maximum stability (nobody depends on it, it depends on many)
I = 1 → Maximum instability (many depend on it, it depends on none)
```

### Abstraction (A)
```
A = Total Abstractions / Total Classes
A ∈ [0, 1]

A = 0 → 100% concrete
A = 1 → 100% abstract
```

### Distance from Main Sequence (D)
```
D = |A + I - 1|
D ∈ [0, 1]

D ≈ 0 → On Main Sequence (ideal)
D ≈ 1 → Zone of Pain or Zone of Uselessness
```

**Zones**:
- **Zone of Pain** (A=0, I=0): Concrete and stable package — hard to change
- **Zone of Uselessness** (A=1, I=1): Abstract and unstable package — no value
- **Main Sequence** (A + I = 1): Ideal balance

## Rationale

**deMGoncalves Rules 015–020** implement the 6 principles:

- **Critical severity (🔴)**: ADP (018), SAP (020) — break architecture
- **High severity (🟠)**: REP (015), CCP (016), SDP (019) — require justification
- **Medium severity (🟡)**: CRP (017) — expected improvement

**Related skills:**
- [`solid`](../solid/SKILL.md) — depends: REP/CCP/CRP depend on SRP and OCP
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — complements: OC complements at class level

## Usage Examples

### @architect: Organize new module
```typescript
// Apply CCP: group classes that change together
src/
├── user/                  // Domain entity
│   ├── User.ts
│   ├── UserService.ts
│   ├── UserRepository.ts
│   └── UserFactory.ts
└── billing/               // Other context
    ├── Invoice.ts
    ├── Payment.ts
    └── BillingService.ts
```

### @reviewer: Detect ADP violation (cycle)
```typescript
// FIXME: Cycle detected — Order → Payment → Order
// Order.ts
import { Payment } from './Payment';

// Payment.ts
import { Order } from './Order';  // violation

// Solution: extract interface
interface PaymentProcessor {
  process(amount: number): Promise<void>;
}
```

### @reviewer: Calculate SDP/SAP metrics
```bash
# domain/ module
# Fan-in: 15 (15 modules depend on it)
# Fan-out: 3 (it depends on 3 modules)

I = 3 / (15 + 3) = 0.167  # Stable ✅
A = 8 / 12 = 0.667        # 67% abstract ✅
D = |0.667 + 0.167 - 1| = 0.166  # On Main Sequence ✅
```

---

**Created on**: 2026-04-01
**Version**: 1.0.0
