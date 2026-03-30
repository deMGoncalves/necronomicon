---
name: poeaa
description: Referência dos principais Patterns of Enterprise Application Architecture (PoEAA) de Martin Fowler. Use quando @architect precisa projetar camadas de domínio, persistência ou apresentação em aplicações enterprise JavaScript/TypeScript.
model: haiku
allowed-tools: Read, Write, Edit
user-invocable: true
location: managed
metadata:
  version: "2.0.0"
  category: design-patterns
---

# PoEAA — Patterns of Enterprise Application Architecture

Patterns para aplicações enterprise organizados por camada arquitetural.

---

## Quando Usar

- @architect: fase Research para projetar camadas de domínio e persistência
- Ao decidir: Transaction Script vs Domain Model?
- Ao decidir: Active Record vs Data Mapper vs Repository?
- @developer: ao implementar camadas de serviço e repositório

## Patterns por Camada

| Camada | Pattern | Complexidade | Referência |
|--------|---------|--------------|------------|
| Domain Logic | Transaction Script | Simples | [transaction-script.md](references/transaction-script.md) |
| Domain Logic | Domain Model | Complexa | [domain-model.md](references/domain-model.md) |
| Domain Logic | Table Module | Moderada | [table-module.md](references/table-module.md) |
| Data Source | Active Record | Simples | [active-record.md](references/active-record.md) |
| Data Source | Data Mapper | Complexa | [data-mapper.md](references/data-mapper.md) |
| Data Source | Repository | Complexa | [repository.md](references/repository.md) |
| Data Source | Table Data Gateway | Simples | [table-data-gateway.md](references/table-data-gateway.md) |
| Data Source | Row Data Gateway | Simples | [row-data-gateway.md](references/row-data-gateway.md) |
| Object-Relational | Unit of Work | Moderada | [unit-of-work.md](references/unit-of-work.md) |
| Object-Relational | Identity Map | Moderada | [identity-map.md](references/identity-map.md) |
| Object-Relational | Lazy Load | Moderada | [lazy-load.md](references/lazy-load.md) |
| Web Presentation | MVC | Moderada | [mvc.md](references/mvc.md) |
| Web Presentation | Front Controller | Moderada | [front-controller.md](references/front-controller.md) |
| Web Presentation | Page Controller | Simples | [page-controller.md](references/page-controller.md) |
| Web Presentation | Application Controller | Complexa | [application-controller.md](references/application-controller.md) |

## Decisão Rápida

| Complexidade do Domínio | Pattern Recomendado |
|------------------------|---------------------|
| Simples, poucas regras | Transaction Script |
| Moderada | Table Module |
| Rica, muitas regras | Domain Model |

| Acesso a Dados | Pattern Recomendado |
|----------------|---------------------|
| Simples, objeto = linha DB | Active Record |
| Domínio complexo, isolado de DB | Data Mapper + Repository |
| Múltiplas operações atômicas | Unit of Work |

## Fundamentação

- rule 010 (SRP): Domain Model garante cada classe com responsabilidade única
- rule 014 (DIP): Repository isola domínio da infraestrutura de dados
- rule 021 (DRY): Unit of Work centraliza persistência
- rule 022 (KISS): Transaction Script quando domínio não justifica complexidade
