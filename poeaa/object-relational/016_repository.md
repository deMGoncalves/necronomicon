# Repository

**Tipo**: Padrão Object-Relational (Metadados)

---

## Intenção e Objetivo

Mediar entre as camadas de domínio e de mapeamento de dados usando uma interface semelhante a uma coleção para acessar objetos de domínio, encapsulando toda a lógica de persistência e consulta.

## Também Conhecido Como

- Collection-Like Interface
- Persistence Mediator
- Domain Object Store

---

## Motivação

Em aplicações com lógica de domínio rica, o código de domínio frequentemente precisa recuperar e armazenar objetos (ex.: buscar todos os pedidos de um cliente, salvar um novo produto). Se o código de domínio depender diretamente de Data Mappers ou acessar o banco de dados diretamente, ele fica poluído com detalhes de infraestrutura e acoplado à estratégia de persistência.

O Repository resolve esse problema fornecendo uma interface que simula uma coleção em memória de objetos de domínio. Da perspectiva do código de domínio, um Repository é como um `Set<Order>` — você pode adicionar, remover e buscar pedidos sem saber nada sobre SQL, Data Mappers ou detalhes de banco de dados. Por exemplo: `repository.add(newOrder)`, `repository.findById(id)`, `repository.findByCustomer(customerId)`.

Internamente, o Repository delega a Data Mappers, Query Objects e gerencia Identity Maps e Unit of Work. Ele centraliza toda a lógica de acesso a dados para um tipo de agregado, fornecendo métodos de busca ricos e específicos do domínio. Isso mantém o domínio limpo, testável (Repositories podem ser mockados) e permite mudar a implementação de persistência sem afetar o domínio.

---

## Aplicabilidade

Use Repository quando:

- Você possui um Domain Model rico e quer mantê-lo livre de código de persistência
- Múltiplas fontes de dados (banco de dados, cache, API externa) precisam ser acessadas de forma uniforme
- Você quer centralizar lógica de query complexa em vez de espalhá-la pelo domínio
- A estratégia de persistência pode mudar (trocar ORM, migrar para NoSQL) e você quer isolar o impacto
- Você precisa de métodos de busca específicos do domínio (ex.: `findActive()`, `findExpiringOn(date)`)
- A testabilidade é importante — Repositories são facilmente mockáveis para testes unitários

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                  Camada de Domínio (Client)                  │
│                                                              │
│  service = new OrderService(orderRepository)                 │
│  order = orderRepository.findById(123)                       │
│  order.approve()                                             │
│  orderRepository.save(order)                                 │
└────────────────────────────┬─────────────────────────────────┘
                             │ usa
                ┌────────────▼────────────┐
                │   <<interface>>         │
                │   IOrderRepository      │
                │ ─────────────────────   │
                │ + findById(id): Order   │
                │ + findByCustomer(id): []│
                │ + findActive(): []      │
                │ + add(order): void      │
                │ + remove(order): void   │
                └────────────△────────────┘
                             │ implementa
                ┌────────────┴────────────┐
                │  OrderRepositoryImpl    │
                │ ─────────────────────   │
                │ - mapper: OrderMapper   │
                │ - identityMap: Map      │
                │ - unitOfWork: UoW       │
                │ + findById(id): Order   │
                │ + findByCustomer(id): []│
                └────────────┬────────────┘
                             │ usa
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────▼──────┐  ┌────────▼────────┐  ┌─────▼────────┐
│ Data Mapper    │  │ Identity Map    │  │ Unit of Work │
│ (SQL/ORM)      │  │ (Cache)         │  │ (Tracking)   │
└────────────────┘  └─────────────────┘  └──────────────┘
```

---

## Participantes

- **Repository Interface** (`IOrderRepository`): Define o contrato para acesso aos objetos de domínio. Os métodos são expressos em termos de domínio, não de persistência (ex.: `findExpiringToday()` e não `SELECT * WHERE...`).

- **Concrete Repository** (`OrderRepositoryImpl`): Implementa a interface, coordenando Data Mappers, Identity Map, Unit of Work e Query Objects para executar operações de persistência.

- **Domain Objects** (`Order`, `Customer`): Objetos de negócio completamente agnósticos de como são persistidos. Não possuem dependências de infraestrutura.

- [**Data Mapper**](../data-source/004_data-mapper.md): Realiza o trabalho efetivo de traduzir objetos de domínio para registros de banco de dados e vice-versa. O Repository delega aos Mappers.

- [**Identity Map**](002_identity-map.md): Mantém o cache de objetos já carregados para garantir que uma única instância represente cada entidade (identidade do objeto).

- **Unit of Work**: Rastreia mudanças nos objetos carregados via Repository para coordenar a persistência transacional.

---

## Colaborações

Quando o código de domínio (ex.: Service Layer) solicita `repository.findById(123)`, o Repository primeiro consulta o Identity Map. Se o objeto estiver em cache, retorna imediatamente. Se não, delega ao Data Mapper que executa SELECT no banco de dados, constrói o objeto Order, o registra no Identity Map e o retorna.

Para `repository.save(order)`, se o Repository estiver integrado com o Unit of Work, ele apenas registra o objeto no UoW como modificado. O UoW decide quando fazer flush (commit) e coordena com os Mappers para gerar o SQL apropriado (INSERT ou UPDATE). Se não usar UoW, o Repository invoca diretamente `mapper.update(order)`.

Métodos de busca específicos (`findByCustomer(customerId)`) constroem Query Objects ou delegam a métodos especializados do Mapper que executam queries customizadas retornando listas de objetos.

---

## Consequências

### Vantagens

1. **Isolamento do Domínio**: O código de domínio não contém SQL, ORM ou detalhes de persistência — permanece puro.
2. **Interface Orientada ao Domínio**: Métodos de busca expressam conceitos de negócio (`findOverdue()`) em vez de SQL genérico.
3. **Testabilidade**: Repositories podem ser facilmente mockados para testes unitários de serviços de domínio.
4. **Centralização de Queries**: Toda a lógica de acesso a dados para um agregado está em um único lugar, fácil de manter.
5. **Troca de Implementação**: Substituir a persistência (SQL → NoSQL, ORM → customizado) não afeta o código de domínio.
6. **Cache Transparente**: Identity Map e cache de segundo nível podem ser gerenciados internamente pelo Repository.

### Desvantagens

1. **Camada Adicional**: Adiciona abstração entre domínio e persistência, aumentando o número de classes.
2. **Overhead de Performance**: Cada operação passa por múltiplas camadas (Repository → Mapper → SQL), adicionando custo.
3. **Tentação do Repository Genérico**: Repositories genéricos (`IRepository<T>`) perdem métodos específicos do domínio e se tornam apenas CRUD.
4. **Complexidade de Agregado**: Definir fronteiras de agregado para determinar quando usar Repositories separados pode ser difícil.
5. **Proliferação de Métodos de Query**: Métodos de busca específicos podem se multiplicar, criando muitos métodos similares.

---

## Implementação

### Considerações de Implementação

1. **Um Repository por Agregado**: Criar Repositories para raízes de agregado (ex.: `OrderRepository`), não para entidades internas (ex.: não criar `OrderItemRepository`).

2. **Métodos Específicos do Domínio**: Evitar métodos genéricos (`findByCriteria()`). Preferir métodos que expressem intenção de negócio (`findPendingApproval()`).

3. **Retornar Coleções vs. Iterators**: Para resultados grandes, considerar retornar Iterators ou Streams em vez de materializar listas completas em memória.

4. **Integração com Unit of Work**: Decidir se o Repository coordena com o Unit of Work (save apenas registra mudanças) ou opera independentemente (save persiste imediatamente).

5. [**Identity Map**](002_identity-map.md): Repositories devem usar Identity Map para garantir que `findById(1)` chamado duas vezes retorne a mesma instância de objeto.

6. **Padrão Specification**: Para queries dinâmicas, aceitar Specifications como parâmetros: `findAll(specification)`.

### Técnicas de Implementação

1. **Interface Segregada**: Definir interfaces estreitas por agregado (`IOrderRepository`), não uma interface genérica para tudo.

2. **Nomenclatura de Métodos de Query**: Usar convenções de nomenclatura para gerar queries automaticamente (Spring Data JPA): `findByNameAndStatus(name, status)`.

3. **Repositories Somente Leitura**: Para queries puras, criar repositories separados que retornam DTOs, não entidades mutáveis.

4. **Operações em Lote**: Fornecer métodos para operações em lote: `addAll(List<Order>)`, `removeAll(Specification)`.

5. **Repositories Assíncronos**: Em sistemas de alta performance, retornar `CompletableFuture<Order>` ou `Observable<Order>` para operações assíncronas.

6. **Classe Base de Repository**: Criar classe abstrata `AbstractRepository<T>` com implementações comuns (findById, cache) para reduzir duplicação.

---

## Usos Conhecidos

1. **Spring Data JPA**: Framework que gera automaticamente implementações de Repository a partir de interfaces com convenções de nomenclatura.

2. **Domain-Driven Design**: Eric Evans popularizou o Repository como padrão central para acessar agregados em DDD.

3. **Entity Framework (C#)**: `DbSet<T>` age como Repository, fornecendo interface semelhante a coleção para entidades.

4. **Doctrine ORM (PHP)**: `EntityRepository` fornece métodos de busca para entidades com suporte ao Query Builder.

5. **NHibernate**: Permite criar Repositories customizados que encapsulam `ISession` e fornecem métodos de domínio.

6. **Axon Framework**: Em CQRS/Event Sourcing, Repositories gerenciam agregados carregando eventos e persistindo novos eventos.

---

## Padrões Relacionados

- [**Data Mapper**](../data-source/004_data-mapper.md): Repository delega a Data Mappers para executar operações reais de persistência.
- [**Identity Map**](002_identity-map.md): Repositories usam Identity Map para fazer cache de objetos e garantir a identidade do objeto.
- [**Unit of Work**](001_unit-of-work.md): Coordena com o Repository para rastrear mudanças e persistir transacionalmente.
- [**Query Object**](015_query-object.md): Repositories podem usar Query Objects internamente para construir queries complexas.
- [**Lazy Load**](003_lazy-load.md): Repositories podem retornar proxies lazy para evitar carregar objetos completos imediatamente.
- **Specification** (DDD): Repositories aceitam Specifications para queries dinâmicas e compostas.
- [**Service Layer**](../domain-logic/004_service-layer.md): Services usam Repositories para acessar dados sem conhecer detalhes de persistência.

### Relação com Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): interface de persistência
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): encapsular acesso a dados
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): interface com foco definido

---

## Relação com Regras de Negócio

- **[014] Dependency Inversion Principle**: Domínio depende de abstração (interface Repository), não de detalhes de persistência.
- **[010] Single Responsibility Principle**: Repository tem a única responsabilidade de mediar o acesso a agregados de um tipo.
- **[022] Priorização de Simplicidade e Clareza**: Interface semelhante a coleção é mais clara do que expor SQL/ORM ao domínio.
- **[043] Backing Services como Recursos**: Banco de dados é tratado como recurso acoplável por meio da abstração do Repository.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
