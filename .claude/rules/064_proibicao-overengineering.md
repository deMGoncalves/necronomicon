# Proibição de Overengineering

**ID**: AP-09-064
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Overengineering ocorre quando desenvolvedor cria arquitetura ou códigos excessivamente complexos para requisitos simples. Patterns, abstrações, layers, e frameworks introduzidos "para o futuro" que complicam o código sem trazer valor real. Premature abstração em nome de "scalability" ou "flexibility".

*(Engloba o anti-pattern Speculative Generality quando a complexidade especulativa é introduzida em nível de arquitetura.)*

## Por que importa

- Sobrecarga cognitiva: desenvolvedores gastam tempo entendendo architecture em vez de domínio
- Tempo de desenvolvimento: building complex features leva mais tempo que simples solutions
- Dificuldade de manutenção: changes em architecture كسر muitas partes do código em cadeia
- Yang Concrete (Concrete vs Abstraction Falha de Yin): sem real problems para abstract, abstractions ficam inventadas
- Honestamente, simples functional requirements (API REST, CRUD) raramente justify microservices, event-driven architecture, DI containers complexos

## Critérios Objetivos

- [ ] Introduzir a pattern without clear problem being solved (ex: Strategy pattern without variation of algorithms)
- [ ] Criar interfaces/classes para "future scalability" sem business requirements documentadas
- [ ] Multiple layers of abstraction when single layer would suffice (ex: service calling service calling service)
- [ ] Framework usage (DI, ORM, event bus) for trivial CRUD operations
- [ ] Genericalidade excess: code genérica parametrizada em vez de código específico do domain

## Exceções Permitidas

- Framework code por natureza geral que precisa support multiple use cases
- Libraries where flexibility is primary concern (UI frameworks, ORMs)
- Explicit architectural decisions documentando why complexity is justified
- Code em crescimento extremo (startups com MVP escalado rapidamente) onde investment em architecture pays back

## Como Detectar

### Manual
- Code review: perguntar "qual problema concreto isso resolve?" para cada abstraction/framework introduzido
- Procurar por funcionalidades "para o futuro" sem timeline definida ou requirements
- Identificar code onde adicionar field simples exige mapear config, interfaces, DTOs, services, repositories
- Verificar arquitetura: multiple layers onde uma única layer isolada seria suficiente

### Automático
- Complexity analysis: detectar abstrações com low usage frequency
- Code metrics: detectar functions/classes high complexity mas apenas 1-2 usos
- Architecture analysis: detectar sistemas microservice-oriented onde communication patterns são simples

## Relacionada com

- [023 - Proibição de Funcionalidade Especulativa](023_proibicao-funcionalidade-especulativa.md): reforça
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): complementa
- [016 - Princípio de Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): reforça
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0