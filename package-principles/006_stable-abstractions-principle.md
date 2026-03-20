# Stable Abstractions Principle (SAP)

**ID**: STRUCTURAL-020
**Severity**: 🔴 Critical
**Category**: Structural

---

## O que é

Um pacote deve ser tão abstrato quanto possível (ter interfaces) se for estável, e tão concreto quanto possível se for instável.

## Por que importa

O SAP vincula a estabilidade do pacote (SDP) à sua abstração (DIP). A violação ocorre quando um módulo altamente estável (difícil de mudar) é concreto, impedindo a extensão. Ou quando um módulo instável (fácil de mudar) é abstrato, atrasando a implementação.

## Critérios Objetivos

- [ ] A **Abstração** (A) do pacote, calculada como (Total de Abstrações / Total de Classes), deve ser **alta** (próxima de 1) se sua **Instabilidade (I)** for baixa (próxima de 0).
- [ ] A distância do pacote à *Main Sequence* (D) no plano A/I não deve ser maior que **0.1** (D = |A + I - 1|).
- [ ] Pacotes de alto nível (política) devem ter mais de **60%** de classes abstratas ou interfaces.

## Exceções Permitidas

- **Pacotes de Dados Puros**: Módulos que contêm apenas *Value Objects* ou DTOs e não são projetados para polimorfismo (A e I podem ser baixos).

## Como Detectar

### Manual

Identificar um módulo de negócio importante (estável) que é composto apenas por classes concretas.

### Automático

Análise de dependências: Cálculo das métricas de abstração (A), instabilidade (I) e distância (D) dos pacotes.

## Relacionado a

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reforça
- [019 - Stable Dependencies Principle](../package-principles/005_stable-dependencies-principle.md): complementa
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): reforça
- [011 - Open/Closed Principle](002_open-closed-principle.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
