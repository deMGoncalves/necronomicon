---
name: cdd
description: "CDD (Cognitive-Driven Development) methodology to measure cognitive load via ICP. Use when @reviewer evaluates complexity, calculates ICP per component, or calibrates violation severity."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

## When to Use

Use CDD when you need to:
- **Calculate ICP** of a method/function to quantify cognitive load
- **Assess severity** of rule violations in code review
- **Calibrate decisions** for PR approval/rejection with objective context
- **Identify hot spots** of complexity for priority refactoring

Specific triggers:
- @reviewer analyzes PR with methods > 10 lines or visible nesting
- Developer requests complexity evaluation of legacy code
- Discussion about "this code is complex" without objective metric
- Need to prioritize refactoring among multiple candidates

---

## The ICP Metric

ICP (Intrinsic Complexity Points) quantifies cognitive load via 4 additive components:

```
ICP = CC_base + Nesting + Responsibilities + Coupling
```

**Action thresholds:**
- ICP ≤ 3: 🟢 Excellent — maintain
- ICP 4–6: 🟡 Acceptable — consider refactoring
- ICP 7–10: 🟠 Concerning — refactor before new feature
- ICP > 10: 🔴 Critical — mandatory refactoring

**Project goal:** Average ICP ≤ 4, 0% of methods with ICP > 10.

---

## CDD Code Review Process (3 Steps)

### Step 1 — Quick Scan (2–5min)

Identify high ICP candidates:
- Files/functions with > 20 lines
- Visible nesting of 3+ levels
- Obvious anti-patterns (The Blob, Pyramid of Doom)

### Step 2 — Deep Analysis (10–20min)

For each candidate:
1. **Calculate ICP** (see `references/icp-formula.md`)
2. **Check critical rules** (eval, return null, relative imports)
3. **Comment objectively** on PR with ICP + violated rule

### Step 3 — Contextual Calibration (5min)

Decide action based on context:

| ICP | Context | Action |
|-----|---------|--------|
| ≤ 5 | Any | ✅ Approve |
| 6–7 | Normal feature | 🔄 Request refactoring |
| 6–7 | Critical hotfix | ✅ Approve + technical debt |
| 8–10 | Any | 🔄 Request refactoring |
| > 10 | Any | 🚫 Block |

---

## ICP Components

Complete details in reference files:

- **[[cc-base.md]]** — Cyclomatic Complexity (execution paths)
- **[[nesting.md]]** — Nesting depth (guard clauses)
- **[[responsibilities.md]]** — Number of responsibilities (8 dimensions)
- **[[coupling.md]]** — Direct external dependencies
- **[[icp-formula.md]]** — Complete formula + scoring tables

---

## ICP Calculation Example

```typescript
// Candidate function
async function processPayment(order) {
  if (!order.isPaid) {                              // +1 CC
    const result = paymentGateway.charge(order.total);  // +1 dependency
    if (result.success) {                           // +1 CC, nesting level 2
      order.markAsPaid();
      emailService.sendReceipt(order.email);        // +1 dependency
      return true;
    }
  }
  return false;
}
```

**Calculation:**
- CC = 3 (2 ifs + 1) → CC_base = 1
- Nesting = 2 levels → +1 point
- Responsibilities = 3 (validation, payment, notification) → +1 point
- Coupling = 3 (paymentGateway, order, emailService) → +1 point
- **Total ICP = 4** 🟡 (acceptable)

---

## Prohibitions

- Don't calculate ICP without reading the code
- Don't block PR for ICP 6–7 without considering context (hotfix, test coverage)
- Don't ignore ICP > 10 even in legacy code
- Don't calculate ICP manually — use formula + reference tables
- Don't focus on style/formatting while high ICP is ignored

---

## Rationale

**Related rules:**
- [Rule 001](../../rules/001_nivel-unico-indentacao.md): CC_base and nesting — reinforces
- [Rule 010](../../rules/010_principio-responsabilidade-unica.md): responsibilities — reinforces
- [Rule 014](../../rules/014_principio-inversao-dependencia.md): coupling — reinforces
- [Rule 018](../../rules/018_principio-dependencias-aciclicas.md): coupling — reinforces
- [Rule 022](../../rules/022_priorizacao-simplicidade-clareza.md): CC ≤ 5 — reinforces
- [Rule 066](../../rules/066_proibicao-piramide-do-destino.md): nesting — reinforces

**Related skills:**
- [`complexity`](../complexity/SKILL.md) — reinforces: complexity measures CC_base that CDD uses for ICP
- [`software-quality`](../software-quality/SKILL.md) — complements: software quality includes testability and maintainability that CDD quantifies

**Cognitive Load Theory (John Sweller, 1988):**
- Working memory processes 7±2 chunks (Miller, 1956)
- In active manipulation: **4±1 elements** (contemporary refinement)
- Code with ICP > 5 exceeds working memory capacity
- Consequence: developer constructs incorrect mental model → bugs

**Empirical evidence (Zup Innovation, 2020):**
- Teams with average ICP ≤ 4: 40% fewer regression bugs
- Code with ICP ≤ 3: modification speed 2.5x higher
- ICP > 10: debugging time 4x higher than ICP ≤ 5

**References:**
- [Cognitive-Driven Development (CDD)](https://zup.com.br/blog/cognitive-driven-development-cdd/) — Zup Innovation
- [The Magical Number Seven, Plus or Minus Two](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two) — George Miller (1956)
- [Cognitive Load Theory](https://en.wikipedia.org/wiki/Cognitive_load) — John Sweller (1988)
