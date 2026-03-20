# Acyclic Dependencies Principle (ADP)

**ID**: STRUCTURAL-018
**Severity**: 🔴 Critical
**Category**: Structural

---

## O que é

O grafo de dependências entre pacotes deve ser acíclico, ou seja, não deve haver dependências circulares entre módulos.

## Por que importa

Dependências circulares criam um nó apertado onde as classes dos módulos envolvidos se tornam inseparáveis. Isso impede testes isolados, torna o deploy mais complexo e impossibilita a reutilização individual dos módulos.

## Critérios Objetivos

- [ ] É proibido que o Módulo A dependa do Módulo B e que o Módulo B dependa do Módulo A.
- [ ] Módulos circulares (com laços de dependência) devem ser imediatamente quebrados via DIP (extraindo interface comum).
- [ ] A análise do grafo de dependências deve resultar em um Directed Acyclic Graph (DAG).

## Exceções Permitidas

- **Classes de Infraestrutura**: Dependências circulares entre classes *internas* ao mesmo pacote, desde que não envolvam a interface pública.

## Como Detectar

### Manual

Buscar por `import { B } from 'module-b'` em `module-a` e `import { A } from 'module-a'` em `module-b`.

### Automático

Análise de dependências: `dependency-graph-analysis` (detecta ciclos).

## Relacionado a

- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reforça
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reforça
- [019 - Stable Dependencies Principle](../package-principles/005_stable-dependencies-principle.md): complementa
- [041 - Explicit Dependency Declaration](../twelve-factor/002_explicit-dependency-declaration.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
