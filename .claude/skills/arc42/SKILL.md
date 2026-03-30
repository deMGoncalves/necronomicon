---
name: arc42
description: Template de documentação arquitetural Arc42 com 12 seções. Use quando @architect precisa criar ou atualizar documentação em docs/arc42/.
model: haiku
allowed-tools: Read, Write, Edit
user-invocable: true
location: managed
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

## Fundamentação

- Arquitetura documentada garante onboarding rápido e rastreabilidade de decisões
- Referência: arc42.org template, adaptado para projetos JS/TS
