# Query Object

**Tipo**: Padrão Object-Relational (Metadados)

---

## Intenção e Objetivo

Representar uma query de banco de dados como um objeto que pode ser construído, composto e interpretado programaticamente, eliminando strings SQL hardcoded e habilitando queries type-safe e reutilizáveis.

## Também Conhecido Como

- Criteria API
- Query Builder
- Specification Pattern (quando combinado com Domain Model)

---

## Motivação

Escrever queries SQL como strings literais espalhadas pelo código cria múltiplos problemas. Primeiro, essas strings são opacas para o compilador — erros de sintaxe, nomes de colunas incorretos e tipos incompatíveis são descobertos apenas em tempo de execução. Segundo, construir queries dinamicamente (ex.: adicionar filtros condicionalmente) requer concatenação de strings, que é propensa a erros e vulnerável a SQL injection. Terceiro, queries complexas duplicadas em múltiplos lugares violam o DRY.

O Query Object resolve esses problemas representando a query como uma estrutura de objetos em vez de texto. Por exemplo, em vez de `"SELECT * FROM users WHERE age > 18 AND status = 'ACTIVE'"`, você constrói: `query.select("*").from("users").where(age.greaterThan(18).and(status.equals("ACTIVE")))`. Essa representação orientada a objetos pode ser validada em tempo de compilação (se type-safe), composta dinamicamente sem concatenação perigosa e reutilizada por meio de métodos que retornam fragmentos de query.

O padrão é essencial em sistemas onde as queries não são conhecidas até o tempo de execução (ex.: interfaces de busca avançada onde usuários selecionam filtros), ou onde o mesmo framework precisa gerar SQL para múltiplos bancos de dados (o Query Object é interpretado e traduzido para o dialeto SQL específico do banco de dados alvo).

---

## Aplicabilidade

Use Query Object quando:

- Queries precisam ser construídas dinamicamente com base em entrada do usuário ou condições de negócio
- Você quer evitar SQL hardcoded e ganhar type-safety nas queries (quando possível)
- A aplicação precisa suportar múltiplos bancos de dados e as queries devem ser portáveis
- Queries complexas são reutilizadas em múltiplos lugares e merecem abstração
- Você precisa compor queries a partir de partes (ex.: adicionar filtros, ordenação, paginação condicionalmente)
- O sistema possui interface de busca avançada onde usuários especificam critérios de filtro arbitrários

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                    Código Cliente                             │
│  query = QueryBuilder.select("*")                            │
│            .from("users")                                    │
│            .where(Criteria.eq("status", "ACTIVE")           │
│                   .and(Criteria.gt("age", 18)))             │
│            .orderBy("name")                                  │
│  results = database.execute(query)                           │
└────────────────────────────┬─────────────────────────────────┘
                             │ constrói
                ┌────────────▼────────────┐
                │   Query Object          │
                │ ─────────────────────   │
                │ - selectClause: List    │
                │ - fromClause: Table     │
                │ - whereClause: Criteria │
                │ - orderByClause: List   │
                │ + toSQL(): String       │
                └────────────┬────────────┘
                             │ contém
                ┌────────────▼────────────┐
                │   Criteria              │
                │ ─────────────────────   │
                │ + and(Criteria): Crit   │
                │ + or(Criteria): Crit    │
                │ + toSQL(): String       │
                └──────┬──────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
┌───────▼──────┐ ┌────▼─────┐ ┌──────▼──────┐
│ EqualsCrit   │ │ GreaterTh│ │ AndCriteria │
│ (field, val) │ │ (f, val) │ │ (left,right)│
└──────────────┘ └──────────┘ └─────────────┘

         │ interpretado por
         ▼
┌─────────────────────────┐
│  Query Interpreter      │
│  (Gerador SQL)          │
│ ──────────────────────  │
│ + generateSQL(Query)    │
│ + applyDialect(vendor)  │
└─────────────────────────┘
```

---

## Participantes

- [**Query Object**](015_query-object.md): Representa a estrutura completa de uma query SQL (SELECT, FROM, WHERE, ORDER BY, etc.). Fornece métodos para adicionar cláusulas e gerar o SQL final.

- **Criteria / Specification**: Representa condições lógicas (cláusulas WHERE). Pode ser composto usando operadores booleanos (AND, OR, NOT) para criar expressões complexas.

- **Query Builder**: API fluente que facilita a construção de Query Objects por meio de uma interface type-safe e legível (`.where()`, `.orderBy()`, etc.).

- **Query Interpreter**: Componente responsável por transformar a estrutura de objetos em uma string SQL específica para o dialeto do banco de dados alvo.

- **Database Executor**: Recebe o Query Object, invoca o Interpreter para obter o SQL e executa a query no banco de dados retornando os resultados.

---

## Colaborações

O cliente usa o Query Builder para construir incrementalmente um Query Object, adicionando cláusulas SELECT, FROM, WHERE com Criteria compostos. Por exemplo: `query.where(age.greaterThan(18))` cria uma instância de GreaterThanCriteria e a adiciona à whereClause do Query Object.

Quando o cliente solicita a execução (`database.execute(query)`), o Database Executor passa o Query Object ao Query Interpreter. O Interpreter percorre a estrutura de objetos, chama métodos `toSQL()` em cada componente (Criteria, OrderBy, etc.) e constrói a string SQL final considerando o dialeto do banco de dados. O SQL é então executado e os resultados são retornados.

---

## Consequências

### Vantagens

1. **Type-Safety**: Em linguagens tipadas, Query Objects podem detectar erros em tempo de compilação (campos inexistentes, tipos incompatíveis).
2. **Composição Dinâmica**: Queries podem ser construídas condicionalmente sem concatenação perigosa de strings.
3. **Reutilização**: Fragmentos de query (Criteria comuns) podem ser extraídos em métodos e reutilizados.
4. **Abstração de Banco de Dados**: Query Objects podem ser traduzidos para diferentes dialetos SQL, facilitando a portabilidade.
5. **Prevenção de SQL Injection**: Parâmetros são sempre vinculados corretamente, eliminando o risco de injection.
6. **Testabilidade**: Queries podem ser testadas sem executar no banco de dados — validar a estrutura do Query Object.

### Desvantagens

1. **Curva de Aprendizado**: Desenvolvedores precisam aprender a API do Query Object em vez de escrever SQL diretamente.
2. **Overhead de Performance**: A interpretação do Query Object tem custo computacional comparado ao SQL pré-compilado.
3. **Expressividade Limitada**: Queries muito complexas (window functions, CTEs recursivos) podem ser difíceis ou impossíveis de representar.
4. **Depuração Complicada**: Quando a query falha, é difícil ver o SQL final gerado — requer log do SQL interpretado.
5. **Abstrações Vazadas**: Desenvolvedores ainda precisam entender o SQL subjacente para usar a API efetivamente.

---

## Implementação

### Considerações de Implementação

1. **Escolha da API**: Decidir entre API fluente (method chaining), criteria API (objetos compostos) ou DSL interno. Fluente é mais legível; criteria é mais flexível.

2. **Type-Safety vs. Flexibilidade**: APIs type-safe (usando generics, propriedades tipadas) detectam erros cedo mas são mais verbosas. APIs baseadas em string são flexíveis mas perdem validação.

3. **Suporte a Dialeto**: Implementar a estratégia Interpreter para cada banco de dados (MySQL, PostgreSQL, Oracle) para traduzir Query Objects para SQL específico.

4. **Parâmetros Vinculados**: Sempre usar prepared statements com parâmetros vinculados. Query Objects devem gerar SQL parametrizado, não interpolando valores.

5. **Otimização de Query**: O Interpreter pode aplicar otimizações (reordenar joins, eliminar cláusulas redundantes) durante a tradução.

6. **Cache de SQL**: Fazer cache do SQL gerado para Query Objects idênticos para evitar reinterpretação repetida.

### Técnicas de Implementação

1. **Padrão Composite**: Usar Composite para Criteria — AndCriteria, OrCriteria contêm outros Criteria, permitindo árvores de expressão booleana.

2. **Padrão Visitor**: Implementar o Query Interpreter como Visitor que percorre a estrutura do Query Object gerando SQL.

3. **Padrão Builder**: Usar Builder para construção fluente de queries complexas com validação de estado.

4. **Padrão Specification**: Combinar Query Object com Specification — cada Specification pode gerar um Criteria para ser usado nas queries.

5. **Method Chaining**: Retornar `this` nos métodos do Query Builder para permitir encadeamento: `query.where().orderBy().limit()`.

6. **Expression Trees**: Em linguagens com suporte (C# LINQ), usar árvores de expressão para criar queries type-safe a partir de lambdas.

---

## Usos Conhecidos

1. **Hibernate Criteria API**: API clássica do Hibernate para construir queries programaticamente: `session.createCriteria(User.class).add(Restrictions.eq("status", "ACTIVE"))`.

2. **JPA Criteria API**: Padrão JPA 2.0+ para queries type-safe usando metamodelo gerado: `CriteriaBuilder`, `CriteriaQuery`, `Root`.

3. **LINQ (C#)**: Language Integrated Query — queries são objetos de árvore de expressão que podem ser interpretados para SQL (Entity Framework) ou executados em memória.

4. **SQLAlchemy (Python)**: A Core API permite construir queries usando objetos Python: `select([users]).where(users.c.age > 18)`.

5. **jOOQ (Java)**: DSL type-safe que espelha o SQL: `create.selectFrom(USERS).where(USERS.AGE.gt(18)).orderBy(USERS.NAME)`.

6. **QueryDSL (Java)**: Framework que gera classes de query type-safe a partir de entidades JPA/Hibernate para queries fluentes.

---

## Padrões Relacionados

- [**GoF Interpreter**](../../gof/behavioral/003_interpreter.md): Query Object é um caso especial de Interpreter — interpreta estrutura de objetos em SQL.
- [**GoF Composite**](../../gof/structural/003_composite.md): Criteria são compostos usando AND/OR para formar árvores de expressão.
- [**GoF Builder**](../../gof/creational/002_builder.md): Query Builder usa o padrão Builder para construção fluente de queries.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Diferentes Interpreters (MySQL, PostgreSQL) são Strategies para traduzir o Query Object.
- [**Repository**](016_repository.md): Repositories usam Query Objects internamente para construir queries de busca.
- **Specification** (Domain-Driven Design): Specifications podem ser convertidas em Criteria do Query Object.
- [**Metadata Mapping**](014_metadata-mapping.md): Query Objects usam o metamodelo do Metadata Mapping para validar nomes de campos/tabelas.

### Relação com Rules

- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): query objects expressivos
- [003 - Encapsulamento de Primitivos](../../object-calisthenics/003_encapsulamento-primitivos.md): encapsular queries

---

## Relação com Regras de Negócio

- **[030] Proibição de Funções Inseguras**: Query Objects eliminam SQL injection sempre usando parâmetros vinculados.
- **[021] Proibição de Duplicação de Lógica**: Criteria e fragmentos de query podem ser extraídos e reutilizados, eliminando duplicação.
- **[022] Priorização de Simplicidade e Clareza**: APIs fluentes tornam as queries mais legíveis do que strings SQL concatenadas.
- **[014] Dependency Inversion Principle**: Código de domínio depende de abstração (Query Object), não de detalhes SQL.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
