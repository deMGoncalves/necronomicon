# Aplicação do Dependency Inversion Principle (DIP)

**ID**: BEHAVIORAL-014
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## O que é

Módulos de alto nível não devem depender de módulos de baixo nível. Ambos devem depender de abstrações (interfaces).

## Por que importa

O DIP é crucial para desacoplar a política de negócio da implementação. A violação cria acoplamento forte, dificultando os testes (unitários e de integração) e impedindo que o módulo de alto nível seja reutilizado em um novo contexto.

## Critérios Objetivos

- [ ] A criação de novas instâncias de classes concretas (*new Class()*) é proibida dentro de classes de alto nível (ex.: *Services* e *Controllers*).
- [ ] Módulos de alto nível devem referenciar apenas interfaces ou classes abstratas (o que será injetado).
- [ ] O número de *imports* de classes concretas em construtores deve ser zero (apenas injeção de abstração).

## Exceções Permitidas

- **Entidades e Value Objects**: Classes puramente de dados que podem ser instanciadas livremente.
- **Root Composer**: O módulo de inicialização do sistema onde a injeção de dependência é configurada.

## Como Detectar

### Manual

Buscar por `new ConcreteName()` dentro de código de *Services* ou *Business Logic*.

### Automático

ESLint: `no-new-without-abstraction` (com regras customizadas).

## Relacionado a

- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): reforça
- [015 - Release Reuse Equivalency Principle](001_release-reuse-equivalency-principle.md): reforça
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complementa
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reforça
- [019 - Stable Dependencies Principle](005_stable-dependencies-principle.md): reforça
- [020 - Stable Abstractions Principle](006_stable-abstractions-principle.md): reforça
- [032 - Minimum Test Coverage](../clean-code/cobertura-teste-minima-qualidade.md): complementa
- [041 - Explicit Dependency Declaration](../twelve-factor/002_explicit-dependency-declaration.md): complementa
- [043 - Backing Services as Resources](../twelve-factor/004_backing-services-resources.md): complementa

---

**Criado em**: 2025-10-04
**Atualizado em**: 2025-10-04
**Versão**: 1.1
