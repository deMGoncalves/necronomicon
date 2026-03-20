# Data Mapper

**Classificação**: Padrão Arquitetural de Fonte de Dados

---

## Intenção e Objetivo

Uma camada de Mappers que move dados entre objetos e banco de dados mantendo-os independentes entre si e do próprio mapper. Separa completamente os objetos de domínio da lógica de persistência.

## Também Conhecido Como

- Object-Relational Mapper (ORM)
- Persistence Layer
- Data Access Layer

## Motivação

Quando o Domain Model é rico e complexo, manter os objetos de domínio independentes do banco de dados é crucial. O Data Mapper resolve isso criando uma camada intermediária responsável exclusivamente por transferir dados entre objetos e banco de dados, permitindo que ambos evoluam de forma independente.

Os objetos de domínio não sabem nada sobre o banco de dados — não possuem métodos save(), delete() nem qualquer referência à persistência. São POJOs (Plain Old Objects) puros com lógica de negócio rica. O Data Mapper conhece os dois lados: entende a estrutura do objeto de domínio e a estrutura do banco de dados, traduzindo entre os dois.

Por exemplo, um objeto Order pode ter uma coleção de OrderItems, um valor Money e um relacionamento com Customer. O OrderMapper sabe como decompor Order em múltiplas tabelas (orders, order_items), converter Money para campos decimais e resolver relacionamentos via chaves estrangeiras. Quando o client solicita um Order, o Mapper executa as consultas necessárias, constrói o grafo de objetos completo e retorna um Order totalmente formado. O domínio permanece puro.

## Aplicabilidade

Use Data Mapper quando:

- O Domain Model é complexo com lógica de negócio rica
- O esquema do banco de dados difere significativamente da estrutura dos objetos
- A ignorância de persistência é um requisito importante de design
- A testabilidade da lógica de domínio sem banco de dados é prioridade
- Domain-Driven Design (DDD) é a abordagem arquitetural escolhida
- A incompatibilidade objeto-relacional é significativa

## Estrutura

```
Client (Camada de Aplicação)
└── Usa: Objetos de Domínio (ignorantes de persistência)

Camada de Domínio
├── Order (Entidade - sem conhecimento de persistência)
│   ├── Propriedades: id, customer, items, total
│   ├── addItem(product, quantity)
│   ├── calculateTotal()
│   └── ship()
├── Customer (Entidade)
│   └── placeOrder(items)
└── Money (Value Object)
    └── add(money), multiply(factor)

Camada Data Mapper
├── OrderMapper
│   ├── find(id): Order
│   ├── insert(order)
│   ├── update(order)
│   ├── delete(order)
│   └── Sabe: como decompor Order em tabelas
├── CustomerMapper
│   ├── find(id): Customer
│   └── Mapeia: Customer ↔ banco de dados
└── ProductMapper
    └── find(id): Product

Padrões de Suporte
├── Unit of Work (gerencia transações)
├── Identity Map (garante identidade única)
└── Lazy Load (carrega dados sob demanda)

Banco de Dados
└── Tabelas relacionais
```

## Participantes

- **Objetos de Domínio**: Entidades e Value Objects sem conhecimento de persistência
- [**Data Mapper**](004_data-mapper.md): Classe responsável por mover dados entre objetos e banco de dados
- **Métodos Finder**: Métodos que carregam objetos do banco de dados (find, findBy)
- **Métodos de Persistência**: Métodos que salvam/atualizam/deletam objetos (insert, update, delete)
- **Metadados**: Informações sobre o mapeamento entre objetos e tabelas
- **Unit of Work**: Gerencia mudanças e transações (frequentemente usado com Mapper)
- [**Identity Map**](../object-relational/002_identity-map.md): Garante que o objeto seja carregado apenas uma vez

## Colaborações

- O Client obtém referência ao Objeto de Domínio via Repository ou Service Layer
- O Repository delega ao Data Mapper para carregar o objeto
- O Mapper consulta o Identity Map para verificar se o objeto já foi carregado
- Se não carregado, o Mapper executa o SELECT SQL
- O Mapper constrói o Objeto de Domínio a partir dos dados retornados
- O Mapper registra o objeto no Identity Map e o retorna ao Client
- O Client trabalha com o Objeto de Domínio invocando métodos de negócio
- Quando mudanças são feitas, o Unit of Work rastreia os objetos modificados
- No commit, o Unit of Work consulta os Mappers para persistir as mudanças
- O Mapper traduz o objeto de volta para SQL UPDATE/INSERT/DELETE

## Consequências

### Vantagens

- **Ignorância de persistência**: Domain Model completamente independente do banco de dados
- **Testabilidade**: Objetos de domínio testáveis sem banco de dados
- **Flexibilidade**: O esquema do banco pode mudar sem afetar os objetos
- **Domain Model rico**: Permite design OO complexo sem restrições do banco de dados
- **Separação clara**: Responsabilidades bem separadas entre as camadas
- **Evolução independente**: Domínio e persistência evoluem separadamente

### Desvantagens

- **Complexidade**: Camada adicional significativa; mais código para escrever
- **Overhead de desempenho**: A tradução entre objetos e banco de dados tem custo
- **Curva de aprendizado**: Mais difícil de entender e implementar
- **Metadados**: Requer configuração ou metadados para o mapeamento
- **Depuração**: Mais difícil depurar com camada extra de indireção
- **Overhead para casos simples**: Excessivo para CRUD simples

## Implementação

### Considerações

1. [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Defina como os objetos mapeiam para tabelas (anotações, XML, código)
2. [**Identity Map**](../object-relational/002_identity-map.md): Implemente para garantir identidade dos objetos
3. **Unit of Work**: Use para gerenciar transações e mudanças
4. **Lazy Loading**: Decida quando carregar os relacionamentos
5. **Operações em cascata**: Defina como as mudanças se propagam
6. **Interface de consulta**: Forneça API para consultas complexas

### Técnicas

- [**Identity Field**](../object-relational/004_identity-field.md): Use IDs para correlacionar objetos com linhas
- [**Foreign Key Mapping**](../object-relational/005_foreign-key-mapping.md): Mapeie relacionamentos via chaves estrangeiras
- [**Association Table Mapping**](../object-relational/006_association-table-mapping.md): Mapeie relações muitos-para-muitos
- [**Embedded Value**](../object-relational/008_embedded-value.md): Mapeie Value Objects para colunas
- [**Dependent Mapping**](../object-relational/007_dependent-mapping.md): Mapeie objetos dependentes
- [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Use metadados para configurar o mapeamento
- [**Query Object**](../object-relational/015_query-object.md): Encapsule consultas complexas em objetos

## Usos Conhecidos

- **Hibernate (Java)**: ORM completo usando Data Mapper
- **Entity Framework (.NET)**: ORM da Microsoft com Data Mapper
- **Doctrine (PHP)**: ORM PHP usando o padrão Data Mapper
- **SQLAlchemy (Python)**: ORM Python com Data Mapper
- **TypeORM (TypeScript)**: ORM TypeScript com suporte a Data Mapper
- **Sequelize (Node.js)**: ORM Node com aspectos de Data Mapper

## Padrões Relacionados

- [**Domain Model**](../domain-logic/002_domain-model.md): Data Mapper persiste Domain Model rico
- [**Active Record**](003_active-record.md): Alternativa que mistura persistência com domínio
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Gerencia transações sobre objetos mapeados
- [**Identity Map**](../object-relational/002_identity-map.md): Mantém identidade única dos objetos
- [**Lazy Load**](../object-relational/003_lazy-load.md): Carrega dados sob demanda
- [**Repository**](../object-relational/016_repository.md): Interface de alto nível sobre Data Mapper
- [**Query Object**](../object-relational/015_query-object.md): Encapsula consultas complexas
- [**Metadata Mapping**](../object-relational/014_metadata-mapping.md): Configura o mapeamento

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separa persistência do domínio
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): domínio não depende da infra
- [032 - Test Coverage](../../clean-code/cobertura-teste-minima-qualidade.md): facilita testes unitários
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): objetos com comportamento rico

---

**Criado em**: 2025-01-11
**Versão**: 1.0
