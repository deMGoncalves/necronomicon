# Uso Obrigatório de Coleções de Primeira Classe

**ID**: STRUCTURAL-004
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

Determina que qualquer coleção (lista, array, map) com lógica de negócio ou comportamento associado deve ser encapsulada em uma classe dedicada (*First Class Collection*).

## Por que importa

Coleções nativas violam o SRP se possuírem lógica de manipulação distribuída. Encapsular a coleção centraliza a responsabilidade, facilita a adição de comportamentos (por exemplo, filtros, somas) e impede que o estado interno seja exposto e modificado pelos clientes.

## Critérios Objetivos

- [ ] Tipos de coleção nativa (Array, List, Map) não devem ser passados como parâmetros ou retornados por métodos públicos, exceto em DTOs puros.
- [ ] Cada coleção com significado de domínio deve ser envolvida por uma classe dedicada (por exemplo, `OrderList`, `Employees`).
- [ ] A classe da coleção deve fornecer métodos de comportamento (por exemplo, `add()`, `filterByStatus()`), e não apenas acesso direto aos elementos.

## Exceções Permitidas

- **Interfaces de Baixo Nível**: Coleções usadas puramente como estruturas de dados internas sem lógica de negócio associada (por exemplo, `tokens` em um *scanner*).
- **APIs de Framework**: Uso de coleções em interfaces de Framework (por exemplo, React, ORMs) que as exigem.

## Como Detectar

### Manual

Verificar o uso de `Array.prototype` (map, filter, reduce) em métodos de classes que não são *First Class Collections*.

### Automático

ESLint: Regras customizadas para proibir o retorno de `Array` em classes de domínio.

## Relacionado a

- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reforça
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reforça
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reforça
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): complementa
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
