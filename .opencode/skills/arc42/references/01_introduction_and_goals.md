# §1 — Introdução e Objetivos

**Seção:** 1 de 12
**Audiência:** Todos (stakeholders, gestão, técnico, dev)
**Quando atualizar:** Ao iniciar o projeto ou quando objetivos de negócio, RF, RNF ou stakeholders mudarem.

---

## Propósito

Esta seção descreve o problema que o sistema resolve, os requisitos funcionais e não-funcionais prioritários, e quem são os stakeholders. É o ponto de partida de toda a documentação arquitetural — todas as decisões posteriores derivam dos objetivos aqui documentados.

## Template

```markdown
# §1 — Introdução e Objetivos

## Visão Geral do Sistema

[Descrever em 2-4 frases o que o sistema faz, qual problema resolve e qual é o valor entregue ao usuário final.]

## Requisitos Funcionais Prioritários

| ID | Requisito | Prioridade | Stakeholder |
|----|-----------|------------|-------------|
| RF-01 | [Descrição do requisito funcional principal] | Alta | [Quem solicitou] |
| RF-02 | [Descrição do requisito funcional secundário] | Média | [Quem solicitou] |
| RF-03 | [Descrição do requisito funcional terciário] | Baixa | [Quem solicitou] |

## Requisitos de Qualidade (RNF)

| ID | Atributo | Meta | Métrica |
|----|----------|------|---------|
| RNF-01 | Performance | [ex: p95 < 200ms] | [Ferramenta de medição] |
| RNF-02 | Disponibilidade | [ex: 99,9% uptime] | [Ferramenta de medição] |
| RNF-03 | Segurança | [ex: OWASP Top 10] | [Auditoria / scan] |
| RNF-04 | Manutenibilidade | [ex: cobertura ≥ 85%] | [Relatório de testes] |

## Stakeholders

| Papel | Nome / Equipe | Interesse Principal | Expectativa |
|-------|---------------|---------------------|-------------|
| Product Owner | [Nome] | [O que espera do sistema em termos de negócio] | [Critério de sucesso] |
| Tech Lead | [Nome] | [Qualidade técnica, arquitetura sustentável] | [Critério de aceitação técnico] |
| Dev Team | [Equipe] | [Clareza de requisitos, ambiente de dev] | [Documentação, specs claras] |
| Usuário Final | [Perfil] | [Facilidade de uso, velocidade] | [UX, performance] |
| Operações / DevOps | [Equipe] | [Observabilidade, deploys seguros] | [Logs, monitoramento, rollback] |

## Critérios de Aceitação do Sistema

- [ ] [Critério mensurável 1 — ex: 95% das requisições respondidas em < 200ms]
- [ ] [Critério mensurável 2 — ex: cobertura de testes de domínio ≥ 85%]
- [ ] [Critério mensurável 3 — ex: zero vulnerabilidades críticas no scan SAST]
```

## Convenções

- RF deve ser rastreável: cada RF aparece nos testes BDD como cenário Gherkin
- RNF deve ter métrica objetiva, não apenas descrição qualitativa
- Stakeholders devem incluir tanto negócio quanto técnico
- Esta seção é a fonte de verdade para §10 (Quality Requirements)

## Relacionada com

- [02_architecture_constraints.md](02_architecture_constraints.md): complementa — restrições derivam dos objetivos
- [10_quality_requirements.md](10_quality_requirements.md): complementa — qualidade deriva dos RNF aqui definidos
- [c4model Level 1](../../c4model/references/01_system-context.md): complementa — visão de contexto ilustra os atores e sistemas aqui listados
- [rule 032 Cobertura de Testes](../../../rules/032_cobertura-teste-minima-qualidade.md): complementa — RNF de qualidade de código

---

**Arc42 Seção:** §1
**Fonte:** arc42.org — arc42 Template, adaptado para pt-BR
