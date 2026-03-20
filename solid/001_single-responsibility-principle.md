# Aplicação do Single Responsibility Principle (SRP)

**ID**: BEHAVIORAL-010
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## O que é

Exige que uma classe ou módulo tenha apenas uma razão para mudar, o que implica que deve ter uma única responsabilidade.

## Por que importa

A violação do SRP causa **baixa coesão** e **alto acoplamento**, tornando classes frágeis e difíceis de testar. Aumenta o custo de manutenção, pois uma mudança em uma área de negócio pode quebrar outra.

## Critérios Objetivos

- [ ] Uma classe não deve conter lógica de negócio e lógica de persistência ao mesmo tempo (ex.: *Service* e *Repository* juntos).
- [ ] O número de métodos públicos em uma classe não deve exceder **7**.
- [ ] O **Lack of Cohesion in Methods (LCOM)** deve ser menor que 0.75.

## Exceções Permitidas

- **Classes Utilitárias/Helper**: Classes estáticas que agrupam funções puras sem estado para manipulação genérica de dados (ex.: formatadores de data).

## Como Detectar

### Manual

Pergunte: "Se houver uma mudança no requisito X e no requisito Y, essa classe precisa ser alterada nas duas situações?" (SRP violado se a resposta for sim).

### Automático

SonarQube: Alta `Cognitive Complexity` e alto `LCOM (Lack of Cohesion in Methods)`.

## Relacionado a

- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reforça
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reforça
- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): complementa
- [025 - Prohibition of The Blob Anti-Pattern](../clean-code/proibicao-anti-padrao-blob.md): complementa
- [021 - Prohibition of Logic Duplication](../clean-code/proibicao-duplicacao-logica.md): reforça
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): reforça
- [015 - Release Reuse Equivalency Principle](001_release-reuse-equivalency-principle.md): reforça
- [016 - Common Closure Principle](002_common-closure-principle.md): reforça
- [032 - Minimum Test Coverage](../clean-code/cobertura-teste-minima-qualidade.md): reforça
- [033 - Parameter Limit per Function](../clean-code/limite-parametros-funcao.md): reforça
- [034 - Consistent Class and Method Names](../clean-code/nomes-classes-metodos-consistentes.md): reforça
- [037 - Prohibition of Flag Arguments](../clean-code/proibicao-argumentos-sinalizadores.md): reforça
- [038 - Query Inversion Principle](../clean-code/conformidade-principio-inversao-consulta.md): reforça
- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): complementa
- [047 - Concurrency via Processes](../twelve-factor/008_concurrency-via-processes.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
