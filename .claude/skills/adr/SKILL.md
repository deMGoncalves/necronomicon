---
name: adr
description: Template para Architecture Decision Records (ADR). Use quando @architect precisar documentar uma decisão arquitetural importante — ao escolher entre tecnologias, patterns ou abordagens que impactam o projeto a longo prazo.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# ADR (Architecture Decision Records)

Template para documentar decisões arquiteturais importantes de forma rastreável.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Toda decisão técnica significativa: escolha de tecnologia, pattern arquitetural, abordagem de design com impacto a longo prazo |
| **Prerequisites** | Contexto claro do problema; pelo menos duas alternativas consideradas; entendimento dos trade-offs |
| **Constraints** | Não aplica a decisões reversíveis de baixo impacto; não substituir ADR existente — criar novo com status Superseded |
| **Scope** | Criação e manutenção de arquivos em `docs/adr/`; numeração sequencial; ciclo de vida de decisões arquiteturais |

---

## Quando Usar

- Ao tomar uma decisão técnica significativa (escolha de tecnologia, pattern arquitetural, abordagem de design)
- Na fase 4 (Docs): @architect cria ADR para cada decisão importante da feature implementada
- Quando uma decisão anterior é revisada ou substituída

## Template ADR

→ Veja [`references/adr-template.md`](references/adr-template.md) para o template completo.

## Numeração

- ADRs numeradas sequencialmente: ADR-001, ADR-002, ...
- Nome de arquivo: `NNN_titulo-kebab-case.md`
- Nunca deletar ADRs — marcar como Deprecated ou Superseded
- Manter índice em docs/adr/README.md

## Categorias Comuns de ADR

| Categoria | Exemplos |
|----------|----------|
| Escolha de tecnologia | DB, framework, runtime, biblioteca |
| Pattern arquitetural | Pipeline, MVC, Event Sourcing, CQRS |
| Pattern de design de código | Value Objects, Repository, DIP |
| Infraestrutura | Deploy, CI/CD, monitoramento |
| Integração | API externa, protocolo, autenticação |

## Exemplos

```markdown
// ❌ Ruim — decisão documentada como comentário de código
// usamos JWT porque é mais simples (autor: João, 2024-01)
// não sei por que não usamos sessions, mas ficou assim

---

// ✅ Bom — ADR com contexto, decisão e consequências
# ADR-019: Autenticação JWT

**Status:** Accepted
**Date:** 2024-01-15

## Contexto

Sistema necessita autenticação stateless para escalar horizontalmente.
Usuários acessam de múltiplos dispositivos.
Previsão de 100k usuários simultâneos no primeiro ano.

## Decisão

Usar JWT (JSON Web Tokens) com refresh tokens armazenados em Redis.
Não usar sessions em memória do servidor.

## Alternativas Consideradas

| Alternativa | Prós | Contras |
|-------------|------|------|
| JWT (escolhido) | Stateless, escala horizontal, sem lookup DB por request | Revogação de token requer blacklist/Redis |
| Sessions em memória | Simples, revogação imediata | Não escala horizontalmente, exige sticky sessions |
| OAuth 2.0 completo | Padrão da indústria, suporte a SSO | Alta complexidade para caso de uso atual |

## Consequências

### Positivas
✅ Escalabilidade horizontal sem sticky sessions
✅ Baixa latência: sem query em DB a cada request
✅ Suporte multi-plataforma (web, mobile) sem configuração extra

### Negativas / Trade-offs
❌ Revogação de token requer blacklist em Redis (adiciona dependência)
❌ Tokens JWT podem crescer se incluirmos muitos claims
❌ Sem controle de sessão ativa em tempo real sem infraestrutura adicional

## Relacionado a

- ADR-003: Escolha de Redis como cache distribuído (depende)
- arc42 §8: Crosscutting Concepts — Authentication and Authorization

---

**Autor:** @architect · deMGoncalves
```

```markdown
// ❌ Ruim — decisão sem alternativas ou consequências
# ADR-025: Usar PostgreSQL

Decidimos usar PostgreSQL.

---

// ✅ Bom — ADR completo com justificativa e trade-offs
# ADR-025: Banco de Dados Relacional PostgreSQL

**Status:** Accepted
**Date:** 2024-02-10

## Contexto

Sistema de e-commerce precisa de:
- Transações ACID para pedidos e pagamentos
- Queries complexas com JOINs (produtos, categorias, usuários)
- Garantia de integridade referencial
- Suporte a 50k pedidos/dia

## Decisão

Usar PostgreSQL 15 como banco de dados principal.
Usar extensions: pgvector (busca semântica futura), pg_stat_statements (monitoramento).

## Alternativas Consideradas

| Alternativa | Prós | Contras |
|-------------|------|------|
| PostgreSQL (escolhido) | ACID, JOINs eficientes, suporte a JSON, maturidade | Escalabilidade horizontal limitada |
| MongoDB | Escalabilidade horizontal simples, schema flexível | Transações multi-documento pouco confiáveis, queries complexas difíceis |
| MySQL | Maturidade, muitas ferramentas | Performance de JOINs inferior ao Postgres, suporte a JSON limitado |

## Consequências

### Positivas
✅ Garantias ACID para transações financeiras
✅ Queries complexas com índices B-tree otimizados
✅ Suporte nativo a JSON (JSONB) para dados semi-estruturados

### Negativas / Trade-offs
❌ Escalabilidade horizontal requer sharding manual (complexidade futura)
❌ Réplicas de leitura assíncronas podem ter lag em reads

## Relacionado a

- ADR-019: Autenticação JWT (ambos dependem de transações consistentes)
- arc42 §7: Deployment View — infraestrutura de banco de dados

---

**Autor:** @architect · deMGoncalves
```

## Proibições

- ❌ Decisões sem contexto ou problema descrito
- ❌ ADRs sem alternativas consideradas
- ❌ Consequências faltando (positivas e negativas)
- ❌ Status não documentado ou mudanças de status sem novo ADR
- ❌ ADRs deletadas — usar Deprecated ou Superseded

## Justificativa

- ADRs garantem rastreabilidade do "por que chegamos aqui"
- Evita repetir debates já resolvidos
- Fonte: Michael Nygard - Documenting Architecture Decisions (2011)
