# Query Object

**Type**: Object-Relational Mapping Pattern (Metadata)

---

## Intent and Purpose

Represent a database query as an object that can be constructed, composed, and interpreted programmatically, eliminating hardcoded SQL strings and enabling type-safe, reusable queries.

## Also Known As

- Criteria API
- Query Builder
- Specification Pattern (when combined with Domain Model)

---

## Motivation

Writing SQL queries as literal strings scattered throughout code creates multiple problems. First, these strings are opaque to the compiler — syntax errors, incorrect column names, and incompatible types are only discovered at runtime. Second, building queries dynamically (e.g., adding filters conditionally) requires string concatenation, which is error-prone and vulnerable to SQL injection. Third, complex queries duplicated in multiple places violate DRY.

Query Object solves these problems by representing the query as an object structure instead of text. For example, instead of `"SELECT * FROM users WHERE age > 18 AND status = 'ACTIVE'"`, you build: `query.select("*").from("users").where(age.greaterThan(18).and(status.equals("ACTIVE")))`. This object-oriented representation can be validated at compile-time (if type-safe), composed dynamically without dangerous concatenation, and reused through methods that return query fragments.

The pattern is essential in systems where queries are not known until runtime (e.g., advanced search interfaces where users select filters), or where the same framework needs to generate SQL for multiple databases (the Query Object is interpreted and translated to the specific SQL dialect of the target database).

---

## Applicability

Use Query Object when:

- Queries need to be built dynamically based on user input or business conditions
- You want to avoid hardcoded SQL and gain type-safety in queries (when possible)
- The application needs to support multiple databases and queries must be portable
- Complex queries are reused in multiple places and deserve abstraction
- You need to compose queries from parts (e.g., add filters, ordering, pagination conditionally)
- The system has an advanced search interface where users specify arbitrary filter criteria

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                    Client Code                               │
│  query = QueryBuilder.select("*")                            │
│            .from("users")                                    │
│            .where(Criteria.eq("status", "ACTIVE")           │
│                   .and(Criteria.gt("age", 18)))             │
│            .orderBy("name")                                  │
│  results = database.execute(query)                           │
└────────────────────────────┬─────────────────────────────────┘
                             │ builds
                ┌────────────▼────────────┐
                │   Query Object          │
                │ ─────────────────────   │
                │ - selectClause: List    │
                │ - fromClause: Table     │
                │ - whereClause: Criteria │
                │ - orderByClause: List   │
                │ + toSQL(): String       │
                └────────────┬────────────┘
                             │ contains
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

         │ interpreted by
         ▼
┌─────────────────────────┐
│  Query Interpreter      │
│  (SQL Generator)        │
│ ──────────────────────  │
│ + generateSQL(Query)    │
│ + applyDialect(vendor)  │
└─────────────────────────┘
```

---

## Participants

- [**Query Object**](015_query-object.md): Represents the complete structure of an SQL query (SELECT, FROM, WHERE, ORDER BY, etc). Provides methods to add clauses and generate final SQL.

- **Criteria / Specification**: Represents logical conditions (WHERE clauses). Can be composed using boolean operators (AND, OR, NOT) to create complex expressions.

- **Query Builder**: Fluent API that facilitates construction of Query Objects through a type-safe, readable interface (`.where()`, `.orderBy()`, etc).

- **Query Interpreter**: Component responsible for transforming the object structure into an SQL string specific to the target database dialect.

- **Database Executor**: Receives the Query Object, invokes the Interpreter to obtain SQL, and executes the query on the database returning results.

---

## Collaborations

The client uses the Query Builder to incrementally build a Query Object, adding SELECT, FROM, WHERE clauses with composed Criteria. For example: `query.where(age.greaterThan(18))` creates an instance of GreaterThanCriteria and adds it to the Query Object's whereClause.

When the client requests execution (`database.execute(query)`), the Database Executor passes the Query Object to the Query Interpreter. The Interpreter traverses the object structure, calls `toSQL()` methods on each component (Criteria, OrderBy, etc), and builds the final SQL string considering the database dialect. The SQL is then executed and results are returned.

---

## Consequences

### Advantages

1. **Type-Safety**: In typed languages, Query Objects can detect errors at compile-time (non-existent fields, incompatible types).
2. **Dynamic Composition**: Queries can be built conditionally without dangerous string concatenation.
3. **Reusability**: Query fragments (common Criteria) can be extracted into methods and reused.
4. **Database Abstraction**: Query Objects can be translated to different SQL dialects, facilitating portability.
5. **SQL Injection Prevention**: Parameters are always properly bound, eliminating injection risk.
6. **Testability**: Queries can be tested without executing on the database — validate Query Object structure.

### Disadvantages

1. **Learning Curve**: Developers need to learn Query Object API instead of writing SQL directly.
2. **Performance Overhead**: Query Object interpretation has computational cost compared to precompiled SQL.
3. **Limited Expressiveness**: Very complex queries (window functions, recursive CTEs) may be difficult or impossible to represent.
4. **Complicated Debugging**: When query fails, it's hard to see the final generated SQL — requires logging interpreted SQL.
5. **Leaky Abstractions**: Developers still need to understand underlying SQL to effectively use the API.

---

## Implementation

### Implementation Considerations

1. **API Choice**: Decide between fluent API (method chaining), criteria API (composed objects), or internal DSL. Fluent is more readable; criteria is more flexible.

2. **Type-Safety vs Flexibility**: Type-safe APIs (using generics, typed properties) detect errors early but are more verbose. String-based APIs are flexible but lose validation.

3. **Dialect Support**: Implement Interpreter strategy for each database (MySQL, PostgreSQL, Oracle) to translate Query Objects to specific SQL.

4. **Bound Parameters**: Always use prepared statements with bound parameters. Query Objects should generate parameterized SQL, not interpolating values.

5. **Query Optimization**: The Interpreter can apply optimizations (reorder joins, eliminate redundant clauses) during translation.

6. **SQL Caching**: Cache generated SQL for identical Query Objects to avoid repeated reinterpretation.

### Implementation Techniques

1. **Composite Pattern**: Use Composite for Criteria — AndCriteria, OrCriteria contain other Criteria, allowing boolean expression trees.

2. **Visitor Pattern**: Implement Query Interpreter as Visitor that traverses Query Object structure generating SQL.

3. **Builder Pattern**: Use Builder for fluent construction of complex queries with state validation.

4. **Specification Pattern**: Combine Query Object with Specification — each Specification can generate a Criteria to be used in queries.

5. **Method Chaining**: Return `this` in Query Builder methods to allow chaining: `query.where().orderBy().limit()`.

6. **Expression Trees**: In languages with support (C# LINQ), use expression trees to create type-safe queries from lambdas.

---

## Known Uses

1. **Hibernate Criteria API**: Classic Hibernate API for building queries programmatically: `session.createCriteria(User.class).add(Restrictions.eq("status", "ACTIVE"))`.

2. **JPA Criteria API**: JPA 2.0+ standard for type-safe queries using generated metamodel: `CriteriaBuilder`, `CriteriaQuery`, `Root`.

3. **LINQ (C#)**: Language Integrated Query — queries are expression tree objects that can be interpreted to SQL (Entity Framework) or executed in memory.

4. **SQLAlchemy (Python)**: Core API allows building queries using Python objects: `select([users]).where(users.c.age > 18)`.

5. **jOOQ (Java)**: Type-safe DSL that mirrors SQL: `create.selectFrom(USERS).where(USERS.AGE.gt(18)).orderBy(USERS.NAME)`.

6. **QueryDSL (Java)**: Framework that generates type-safe query classes from JPA/Hibernate entities for fluent queries.

---

## Related Patterns

- [**GoF Interpreter**](../../gof/behavioral/003_interpreter.md): Query Object is a special case of Interpreter — interprets object structure into SQL.
- [**GoF Composite**](../../gof/structural/003_composite.md): Criteria are composed using AND/OR to form expression trees.
- [**GoF Builder**](../../gof/creational/002_builder.md): Query Builder uses Builder pattern for fluent query construction.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Different Interpreters (MySQL, PostgreSQL) are Strategies for translating Query Object.
- [**Repository**](016_repository.md): Repositories use Query Objects internally to build search queries.
- **Specification** (Domain-Driven Design): Specifications can be converted to Query Object Criteria.
- [**Metadata Mapping**](014_metadata-mapping.md): Query Objects use Metadata Mapping metamodel to validate field/table names.

### Relation with Rules

- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): expressive query objects
- [003 - Primitive Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md): encapsulate queries

---

## Business Rules Relationship

- **[030] Prohibition of Unsafe Functions**: Query Objects eliminate SQL injection by always using bound parameters.
- **[021] Prohibition of Logic Duplication**: Criteria and query fragments can be extracted and reused, eliminating duplication.
- **[022] Prioritization of Simplicity and Clarity**: Fluent APIs make queries more readable than concatenated SQL strings.
- **[014] Dependency Inversion Principle**: Domain code depends on abstraction (Query Object), not SQL details.

---

**Created on**: 2025-01-10
**Version**: 1.0
