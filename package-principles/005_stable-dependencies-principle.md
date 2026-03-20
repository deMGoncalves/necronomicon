# Stable Dependencies Principle (SDP)

**ID**: STRUCTURAL-019
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

As dependências de um módulo devem apontar na direção da estabilidade. Módulos instáveis (que mudam com frequência) devem depender de módulos estáveis.

## Por que importa

Violações do SDP fazem com que módulos de alto nível (mais importantes para o negócio) dependam de módulos de baixo nível e voláteis, propagando mudanças e reduzindo a testabilidade.

## Critérios Objetivos

- [ ] A **instabilidade** (I) do pacote, calculada como (Dependências de Saída / Total de Dependências), deve ser **menor que** 0.5.
- [ ] Módulos de política de negócio (alto nível) devem ter a menor Instabilidade (próxima de 0).
- [ ] Os pacotes mais utilizados (alto grau de estabilidade) não devem depender de pacotes com baixo grau de estabilidade (alto I).

## Exceções Permitidas

- **Elementos de Fronteira**: Elementos na fronteira do sistema (ex.: *Adapters*, *Controllers*) que são voláteis por natureza.

## Como Detectar

### Manual

Identificar a camada de alto nível (ex.: *Domain*) importando classes concretas de camadas externas (ex.: *Infrastructure*).

### Automático

Análise de dependências: Cálculo das métricas de estabilidade de pacotes (I).

## Relacionado a

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reforça
- [018 - Acyclic Dependencies Principle](../package-principles/004_acyclic-dependencies-principle.md): complementa
- [020 - Stable Abstractions Principle](../package-principles/006_stable-abstractions-principle.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
