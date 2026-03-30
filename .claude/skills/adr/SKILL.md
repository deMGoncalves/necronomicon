---
name: adr
description: Template para Architecture Decision Records (ADR). Use quando @architect precisa documentar uma decisão arquitetural importante em docs/adr/.
model: haiku
allowed-tools: Read, Write, Edit
user-invocable: true
location: managed
---

# ADR (Architecture Decision Records)

Template para documentar decisões arquiteturais importantes de forma rastreável.

---

## Quando Usar

- Ao fazer uma decisão técnica significativa (escolha de tecnologia, padrão arquitetural, abordagem de design)
- Na fase 4 (Docs): @architect cria ADR para cada decisão importante da feature implementada
- Quando uma decisão anterior é revisada ou substituída

## Template de ADR

```markdown
# ADR-NNN — [Título da Decisão]

**Status:** [Proposed | Accepted | Deprecated | Superseded by ADR-XXX]
**Data:** AAAA-MM-DD

## Contexto

[Descrever o contexto e o problema que levou a esta decisão. Quais forças estão em jogo?]

## Decisão

[Descrever a decisão tomada em voz ativa. "Decidimos usar X porque..."]

## Alternativas Consideradas

| Alternativa | Prós | Contras |
|-------------|------|---------|
| Opção A (escolhida) | ... | ... |
| Opção B | ... | ... |
| Opção C | ... | ... |

## Consequências

### Positivas
- [Benefícios desta decisão]

### Negativas / Trade-offs
- [Custos e limitações aceitos]

## Relacionada com

- [ADR-NNN — Título]: relação (ex: complementa, depende de, substitui)
- [arc42 §N — Seção]: referência cruzada

---

**Autor:** [Nome] · [Link]
```

## Numeração

- ADRs numerados sequencialmente: ADR-001, ADR-002, ...
- Nome do arquivo: `NNN_titulo-kebab-case.md`
- Nunca deletar ADRs — marcar como Deprecated ou Superseded
- Manter índice em docs/adr/README.md

## Categorias Comuns de ADR

| Categoria | Exemplos |
|-----------|----------|
| Escolha de tecnologia | DB, framework, runtime, biblioteca |
| Padrão arquitetural | Pipeline, MVC, Event Sourcing, CQRS |
| Padrão de design de código | Value Objects, Repository, DIP |
| Infraestrutura | Deploy, CI/CD, monitoramento |
| Integração | API externa, protocolo, autenticação |

## Fundamentação

- ADRs garantem rastreabilidade de "por que chegamos aqui"
- Evita repetir debates já resolvidos
- Fonte: Michael Nygard - Documenting Architecture Decisions (2011)
