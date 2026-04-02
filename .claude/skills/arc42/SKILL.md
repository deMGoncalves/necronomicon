---
name: arc42
description: Template de documentação arquitetural Arc42 com 12 seções. Use quando @architect precisa criar ou atualizar documentação em docs/arc42/ — ao documentar uma nova feature, após mudanças arquiteturais ou na Fase 4 do workflow.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# Arc42

Template de documentação arquitetural com 12 seções padronizadas.

## Quando Usar

- Fase 4 (Docs): @architect sincroniza docs/arc42/ após implementação
- Ao criar um novo projeto: @architect cria a documentação inicial
- Ao fazer decisões arquiteturais importantes: atualizar seções afetadas

## Estrutura das 12 Seções

| Seção | Arquivo | Conteúdo esperado | Referência |
|-------|---------|-------------------|------------|
| §1 Introdução e Objetivos | 01_introduction_and_goals.md | Visão geral, RF, RNF, critérios de aceitação, stakeholders | [01_introduction_and_goals.md](references/01_introduction_and_goals.md) |
| §2 Restrições Arquiteturais | 02_architecture_constraints.md | Restrições técnicas, organizacionais, convenções obrigatórias | [02_architecture_constraints.md](references/02_architecture_constraints.md) |
| §3 Contexto e Escopo | 03_context_and_scope.md | System context diagram, atores externos, sistemas externos, interfaces | [03_context_and_scope.md](references/03_context_and_scope.md) |
| §4 Estratégia de Solução | 04_solution_strategy.md | Decisões fundamentais: tecnologias, arquitetura, qualidade | [04_solution_strategy.md](references/04_solution_strategy.md) |
| §5 Building Block View | 05_building_block_view.md | Decomposição em componentes (nível 1, 2, 3), responsabilidades | [05_building_block_view.md](references/05_building_block_view.md) |
| §6 Runtime View | 06_runtime_view.md | Fluxos de execução, diagramas de sequência, cenários | [06_runtime_view.md](references/06_runtime_view.md) |
| §7 Deployment View | 07_deployment_view.md | Infraestrutura, containers, ambientes (dev, staging, prod) | [07_deployment_view.md](references/07_deployment_view.md) |
| §8 Crosscutting Concepts | 08_concepts.md | Padrões transversais: logging, segurança, tratamento de erros, patterns | [08_concepts.md](references/08_concepts.md) |
| §9 Architecture Decisions | 09_architecture_decisions.md | Índice de todos os ADRs | [09_architecture_decisions.md](references/09_architecture_decisions.md) |
| §10 Quality Requirements | 10_quality_requirements.md | Quality tree, cenários de qualidade, métricas | [10_quality_requirements.md](references/10_quality_requirements.md) |
| §11 Technical Risks | 11_technical_risks.md | Riscos identificados, impacto, mitigação | [11_technical_risks.md](references/11_technical_risks.md) |
| §12 Glossary | 12_glossary.md | Termos do domínio e técnicos com definições | [12_glossary.md](references/12_glossary.md) |

## Formato de Arquivo Arc42

```markdown
# §N — [Título da Seção]

## [Subseção 1]

[Conteúdo com tabelas, listas, diagramas ASCII]

## [Subseção 2]

---

## Relacionada com

- [Referências cruzadas para ADRs, BDD, C4]

---

**Autor:** [Nome] · [Link]
```

## Convenções

- Diagrama de contexto: usar ASCII art ou Mermaid
- Tabelas para atores externos, sistemas, RF, RNF
- Referências cruzadas entre §§ e ADRs/BDD
- Idioma: português brasileiro
- Seção §9 é índice de ADRs (não conteúdo duplicado)

## Exemplos

```markdown
// ❌ Ruim — documentação livre sem estrutura
## Arquitetura
O sistema usa microsserviços e tem um banco PostgreSQL.
Ele se conecta com a API de pagamentos.

// ✅ Bom — Arc42 com seções estruturadas e contexto claro
# §1 — Introdução e Objetivos

## Visão Geral
Sistema de e-commerce para venda de produtos digitais.

## Requisitos Funcionais
| ID   | Requisito                          |
|------|------------------------------------|
| RF-1 | Usuário pode criar conta           |
| RF-2 | Usuário pode adicionar ao carrinho |

## Objetivos de Qualidade
| Qualidade      | Métrica           |
|----------------|-------------------|
| Disponibilidade| 99.9% uptime      |
| Performance    | Latência < 200ms  |

---

# §3 — Contexto e Escopo

## Contexto do Sistema
```
[Usuário] --usa--> [Sistema E-commerce] --integra--> [Gateway Pagamento]
```

## Interfaces Externas
| Sistema         | Protocolo | Responsabilidade      |
|-----------------|-----------|----------------------|
| Gateway Stripe  | REST      | Processar pagamentos |
| Email Service   | SMTP      | Enviar confirmações  |

---

# §5 — Building Block View

## Nível 1 — Containers
- Frontend (React SPA)
- Backend API (Node.js)
- PostgreSQL Database

## Nível 2 — Componentes do Backend
- AuthController
- OrderService
- PaymentGateway (integração externa)

---

# §9 — Decisões Arquiteturais

→ Ver [docs/adr/](../../adr/) para ADRs individuais:
- ADR-001: Escolha de Node.js para backend
- ADR-002: PostgreSQL vs MongoDB
```

## Fundamentação

- Arquitetura documentada garante onboarding rápido e rastreabilidade de decisões
- Referência: arc42.org template, adaptado para projetos JS/TS

**Skills relacionadas:**
- [`c4model`](../c4model/SKILL.md) — reforça: arc42 §5 usa diagramas C4 para building blocks
- [`adr`](../adr/SKILL.md) — reforça: arc42 §9 centraliza ADRs de decisão arquitetural
- [`bdd`](../bdd/SKILL.md) — complementa: arc42 §10 integra com features BDD para requisitos
