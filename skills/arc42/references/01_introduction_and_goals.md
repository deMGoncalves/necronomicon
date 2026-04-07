# §1 — Introduction and Goals

**Section:** 1 of 12
**Audience:** Everyone (stakeholders, management, technical, dev)
**When to update:** When starting the project or when business goals, FR, NFR or stakeholders change.

---

## Purpose

This section describes the problem the system solves, prioritized functional and non-functional requirements, and who the stakeholders are. It's the starting point of all architectural documentation — all subsequent decisions derive from the goals documented here.

## Template

```markdown
# §1 — Introduction and Goals

## System Overview

[Describe in 2-4 sentences what the system does, what problem it solves, and what value it delivers to the end user.]

## Priority Functional Requirements

| ID | Requirement | Priority | Stakeholder |
|----|-------------|----------|-------------|
| FR-01 | [Description of main functional requirement] | High | [Who requested] |
| FR-02 | [Description of secondary functional requirement] | Medium | [Who requested] |
| FR-03 | [Description of tertiary functional requirement] | Low | [Who requested] |

## Quality Requirements (NFR)

| ID | Attribute | Goal | Metric |
|----|-----------|------|--------|
| NFR-01 | Performance | [ex: p95 < 200ms] | [Measurement tool] |
| NFR-02 | Availability | [ex: 99.9% uptime] | [Measurement tool] |
| NFR-03 | Security | [ex: OWASP Top 10] | [Audit / scan] |
| NFR-04 | Maintainability | [ex: coverage ≥ 85%] | [Test report] |

## Stakeholders

| Role | Name / Team | Main Interest | Expectation |
|------|-------------|---------------|-------------|
| Product Owner | [Name] | [What they expect from the system in business terms] | [Success criteria] |
| Tech Lead | [Name] | [Technical quality, sustainable architecture] | [Technical acceptance criteria] |
| Dev Team | [Team] | [Requirements clarity, dev environment] | [Documentation, clear specs] |
| End User | [Profile] | [Ease of use, speed] | [UX, performance] |
| Operations / DevOps | [Team] | [Observability, safe deploys] | [Logs, monitoring, rollback] |

## System Acceptance Criteria

- [ ] [Measurable criterion 1 — ex: 95% of requests responded in < 200ms]
- [ ] [Measurable criterion 2 — ex: domain test coverage ≥ 85%]
- [ ] [Measurable criterion 3 — ex: zero critical vulnerabilities in SAST scan]
```

## Conventions

- FR must be traceable: each FR appears in BDD tests as a Gherkin scenario
- NFR must have objective metric, not just qualitative description
- Stakeholders must include both business and technical
- This section is the source of truth for §10 (Quality Requirements)

## Related to

- [02_architecture_constraints.md](02_architecture_constraints.md): complements — constraints derive from goals
- [10_quality_requirements.md](10_quality_requirements.md): complements — quality derives from NFR defined here
- [c4model Level 1](../../c4model/references/01_system-context.md): complements — context view illustrates actors and systems listed here
- [rule 032 Test Coverage](../../../rules/032_cobertura-teste-minima-qualidade.md): complements — NFR for code quality

---

**Arc42 Section:** §1
**Source:** arc42.org — arc42 Template, adapted for en-US
