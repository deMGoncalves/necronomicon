---
name: adr
description: Template para Architecture Decision Records (ADR). Use quando @architect precisa documentar uma decisão arquitetural importante — ao escolher entre tecnologias, patterns ou abordagens que impactam o projeto a longo prazo.
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

## Quando Usar

- Ao fazer uma decisão técnica significativa (escolha de tecnologia, padrão arquitetural, abordagem de design)
- Na fase 4 (Docs): @architect cria ADR para cada decisão importante da feature implementada
- Quando uma decisão anterior é revisada ou substituída

## Template de ADR

→ Consulte [`references/adr-template.md`](references/adr-template.md) para o template completo.

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

## Exemplos

```markdown
// ❌ Ruim — decisão documentada como comentário no código
// usamos JWT porque é mais simples (autor: João, 2024-01)
// não sei por que não usamos sessões, mas ficou assim

---

// ✅ Bom — ADR com contexto, decisão e consequências
# ADR-019: Autenticação via JWT

**Status:** Aceito
**Data:** 2024-01-15

## Contexto

Sistema precisa de autenticação stateless para escalar horizontalmente.
Usuários acessam de múltiplos dispositivos.
Previsão de 100k usuários simultâneos no primeiro ano.

## Decisão

Usar JWT (JSON Web Tokens) com refresh tokens armazenados em Redis.
Não usar sessões em memória do servidor.

## Alternativas Consideradas

| Alternativa | Prós | Contras |
|-------------|------|---------|
| JWT (escolhida) | Stateless, escala horizontal, sem DB lookup em cada request | Revogação de tokens requer blacklist/Redis |
| Sessões em memória | Simples, revogação imediata | Não escala horizontal, exige sticky sessions |
| OAuth 2.0 completo | Padrão da indústria, suporte SSO | Complexidade alta para caso de uso atual |

## Consequências

### Positivas
✅ Escalabilidade horizontal sem sticky sessions
✅ Latência baixa: sem consulta a DB em cada request
✅ Suporte multiplataforma (web, mobile) sem configuração extra

### Negativas / Trade-offs
❌ Revogação de tokens requer blacklist em Redis (adiciona dependência)
❌ Tokens JWT podem crescer muito se incluirmos muitos claims
❌ Não há controle de sessões ativas em tempo real sem infraestrutura adicional

## Relacionada com

- ADR-003: Escolha de Redis como cache distribuído (depende)
- arc42 §8: Crosscutting Concepts — Autenticação e Autorização

---

**Autor:** @architect · deMGoncalves
```

```markdown
// ❌ Ruim — decisão sem alternativas ou consequências
# ADR-025: Usar PostgreSQL

Decidimos usar PostgreSQL.

---

// ✅ Bom — ADR completo com raciocínio e trade-offs
# ADR-025: Banco de Dados Relacional PostgreSQL

**Status:** Aceito
**Data:** 2024-02-10

## Contexto

Sistema de e-commerce precisa de:
- Transações ACID para pedidos e pagamentos
- Queries complexas com JOINs (produtos, categorias, usuários)
- Integridade referencial garantida
- Suporte a 50k pedidos/dia

## Decisão

Usar PostgreSQL 15 como banco de dados principal.
Usar extensões: pgvector (busca semântica futura), pg_stat_statements (monitoramento).

## Alternativas Consideradas

| Alternativa | Prós | Contras |
|-------------|------|---------|
| PostgreSQL (escolhida) | ACID, JOINs eficientes, JSON support, maturidade | Escalabilidade horizontal limitada |
| MongoDB | Escalabilidade horizontal simples, schema flexível | Sem transações multi-documento confiáveis, queries complexas difíceis |
| MySQL | Maturidade, muitas ferramentas | Performance de JOINs inferior ao Postgres, JSON support limitado |

## Consequências

### Positivas
✅ Garantias ACID para transações financeiras
✅ Queries complexas com índices B-tree otimizados
✅ JSON support nativo (JSONB) para dados semi-estruturados

### Negativas / Trade-offs
❌ Escalabilidade horizontal exige sharding manual (complexidade futura)
❌ Read replicas assíncronas podem ter lag em leituras

## Relacionada com

- ADR-019: Autenticação via JWT (ambos dependem de transações consistentes)
- arc42 §7: Deployment View — infraestrutura de banco de dados

---

**Autor:** @architect · deMGoncalves
```

## Proibições

- ❌ Decisões sem contexto ou problema descrito
- ❌ ADRs sem alternativas consideradas
- ❌ Ausência de consequências (positivas e negativas)
- ❌ Status não documentado ou mudanças de status sem ADR novo
- ❌ ADRs deletados — use Deprecated ou Superseded

## Fundamentação

- ADRs garantem rastreabilidade de "por que chegamos aqui"
- Evita repetir debates já resolvidos
- Fonte: Michael Nygard - Documenting Architecture Decisions (2011)
