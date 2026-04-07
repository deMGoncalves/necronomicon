---
name: arc42
description: Arc42 architectural documentation template with 12 sections. Use when @architect needs to create or update documentation in docs/arc42/ — when documenting a new feature, after architectural changes or in Phase 4 of the workflow.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# Arc42

Architectural documentation template with 12 standardized sections.

## When to Use

- Phase 4 (Docs): @architect syncs docs/arc42/ after implementation
- When creating a new project: @architect creates initial documentation
- When making important architectural decisions: update affected sections

## Structure of 12 Sections

| Section | File | Expected Content | Reference |
|---------|------|------------------|-----------|
| §1 Introduction and Goals | 01_introduction_and_goals.md | Overview, FR, NFR, acceptance criteria, stakeholders | [01_introduction_and_goals.md](references/01_introduction_and_goals.md) |
| §2 Architecture Constraints | 02_architecture_constraints.md | Technical, organizational constraints, mandatory conventions | [02_architecture_constraints.md](references/02_architecture_constraints.md) |
| §3 Context and Scope | 03_context_and_scope.md | System context diagram, external actors, external systems, interfaces | [03_context_and_scope.md](references/03_context_and_scope.md) |
| §4 Solution Strategy | 04_solution_strategy.md | Fundamental decisions: technologies, architecture, quality | [04_solution_strategy.md](references/04_solution_strategy.md) |
| §5 Building Block View | 05_building_block_view.md | Decomposition into components (level 1, 2, 3), responsibilities | [05_building_block_view.md](references/05_building_block_view.md) |
| §6 Runtime View | 06_runtime_view.md | Execution flows, sequence diagrams, scenarios | [06_runtime_view.md](references/06_runtime_view.md) |
| §7 Deployment View | 07_deployment_view.md | Infrastructure, containers, environments (dev, staging, prod) | [07_deployment_view.md](references/07_deployment_view.md) |
| §8 Crosscutting Concepts | 08_concepts.md | Transversal patterns: logging, security, error handling, patterns | [08_concepts.md](references/08_concepts.md) |
| §9 Architecture Decisions | 09_architecture_decisions.md | Index of all ADRs | [09_architecture_decisions.md](references/09_architecture_decisions.md) |
| §10 Quality Requirements | 10_quality_requirements.md | Quality tree, quality scenarios, metrics | [10_quality_requirements.md](references/10_quality_requirements.md) |
| §11 Technical Risks | 11_technical_risks.md | Identified risks, impact, mitigation | [11_technical_risks.md](references/11_technical_risks.md) |
| §12 Glossary | 12_glossary.md | Domain and technical terms with definitions | [12_glossary.md](references/12_glossary.md) |

## Arc42 File Format

```markdown
# §N — [Section Title]

## [Subsection 1]

[Content with tables, lists, ASCII diagrams]

## [Subsection 2]

---

## Related to

- [Cross-references to ADRs, BDD, C4]

---

**Author:** [Name] · [Link]
```

## Conventions

- Context diagram: use ASCII art or Mermaid
- Tables for external actors, systems, FR, NFR
- Cross-references between §§ and ADRs/BDD
- Language: Brazilian Portuguese
- Section §9 is an index of ADRs (not duplicated content)

## Examples

```markdown
// ❌ Bad — free documentation without structure
## Architecture
The system uses microservices and has a PostgreSQL database.
It connects with the payment API.

// ✅ Good — Arc42 with structured sections and clear context
# §1 — Introduction and Goals

## Overview
E-commerce system for selling digital products.

## Functional Requirements
| ID   | Requirement                        |
|------|------------------------------------|
| FR-1 | User can create account            |
| FR-2 | User can add to cart               |

## Quality Goals
| Quality        | Metric            |
|----------------|-------------------|
| Availability   | 99.9% uptime      |
| Performance    | Latency < 200ms   |

---

# §3 — Context and Scope

## System Context
```
[User] --uses--> [E-commerce System] --integrates--> [Payment Gateway]
```

## External Interfaces
| System          | Protocol | Responsibility       |
|-----------------|----------|---------------------|
| Stripe Gateway  | REST     | Process payments    |
| Email Service   | SMTP     | Send confirmations  |

---

# §5 — Building Block View

## Level 1 — Containers
- Frontend (React SPA)
- Backend API (Node.js)
- PostgreSQL Database

## Level 2 — Backend Components
- AuthController
- OrderService
- PaymentGateway (external integration)

---

# §9 — Architecture Decisions

→ See [docs/adr/](../../adr/) for individual ADRs:
- ADR-001: Choice of Node.js for backend
- ADR-002: PostgreSQL vs MongoDB
```

## Rationale

- Documented architecture ensures fast onboarding and decision traceability
- Reference: arc42.org template, adapted for JS/TS projects

**Related skills:**
- [`c4model`](../c4model/SKILL.md) — reinforces: arc42 §5 uses C4 diagrams for building blocks
- [`adr`](../adr/SKILL.md) — reinforces: arc42 §9 centralizes ADRs of architectural decisions
- [`bdd`](../bdd/SKILL.md) — complements: arc42 §10 integrates with BDD features for requirements
