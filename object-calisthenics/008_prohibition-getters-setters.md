# Proibição de Exposição Direta de Estado (Getters/Setters)

**ID**: BEHAVIORAL-008
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## O que é

Proíbe a criação de métodos puramente para acessar ou modificar diretamente o estado interno do objeto (como `getProperty()` e `setProperty()`), reforçando o encapsulamento e o princípio "Tell, Don't Ask".

## Por que importa

A exposição direta do estado interno viola o encapsulamento, forçando o código cliente a decidir a lógica de negócio (*programação procedural*), resultando em classes anêmicas e acoplamento a detalhes de implementação.

## Critérios Objetivos

- [ ] Métodos que retornam o valor exato de uma propriedade interna sem transformações ou lógica são proibidos (*getters* puros).
- [ ] Métodos que apenas atribuem um valor a uma propriedade interna são proibidos (*setters* puros).
- [ ] A interação com o objeto deve ocorrer por meio de métodos que expressam a *intenção* de negócio (por exemplo, `scheduleMeeting()` em vez de `setStatus(Scheduled)`).

## Exceções Permitidas

- **Data Transfer Objects (DTOs)**: Classes puras usadas apenas para transferência de dados entre camadas, sem lógica de negócio.
- **Frameworks de Serialização**: Bibliotecas que exigem *getters* e *setters* para mapeamento.

## Como Detectar

### Manual

Buscar por métodos contendo prefixos `get` ou `set` seguidos de um nome de propriedade, ou métodos que não possuem lógica de negócio própria.

### Automático

ESLint: Regras customizadas para identificar padrões de métodos `get/set` vazios ou triviais.

## Relacionado a

- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reforça
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complementa
- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reforça
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reforça
- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): reforça
- [029 - Object Immutability](../clean-code/imutabilidade-objetos-freeze.md): reforça
- [036 - Side Effect Function Restriction](../clean-code/restricao-funcoes-efeitos-colaterais.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
