# Metadata Mapping

**Type**: Object-Relational Mapping Pattern (Metadata)

---

## Intent and Purpose

Maintain the details of how domain objects map to database structures in metadata files (XML, annotations, JSON) separated from the main code, allowing the persistence framework to configure mapping dynamically.

## Also Known As

- External Mapping
- Configuration-Based Mapping
- Declarative Mapping

---

## Motivation

Encoding object-relational mapping directly in code (hardcoding SQL queries, manually constructing objects from ResultSets) is laborious, repetitive, and error-prone. Each domain class requires substantial mapping code that handles type transformations, column naming, relationships, inheritance, etc. This infrastructure code pollutes domain classes and makes changes difficult.

Metadata Mapping solves this problem by externalizing mapping rules to declarative metadata files. Instead of writing code that says "the `fullName` property maps to the `full_name` column of VARCHAR type", you write a declaration: `<property name="fullName" column="full_name" type="string"/>`. A persistence framework (ORM) reads these metadata at runtime and automatically generates the necessary mapping code.

The advantage is separation of concerns: domain code remains clean and focused on business logic, while technical persistence details live in configuration. Mapping changes (e.g., renaming a column) don't require code recompilation. Different mapping strategies can be applied without touching the domain. The cost is the complexity of learning and maintaining metadata files, and potential loss of type-safety (errors only detected at runtime).

---

## Applicability

Use Metadata Mapping when:

- You have multiple domain classes that need to be persisted and want to avoid repetitive mapping code
- Object-relational mapping is complex (inheritance, relationships, custom types) and would benefit from abstraction
- You want to keep domain code clean and independent of persistence details
- Different developers can work on database schema and domain code independently
- You need to support multiple databases or change mapping strategies without changing code
- A mature ORM framework (Hibernate, Entity Framework, Doctrine) is available to interpret the metadata

---

## Structure

```
┌──────────────────────────────────────────────────────────────┐
│                    Application Code                          │
└────────────────────────────┬─────────────────────────────────┘
                             │ uses
                ┌────────────▼────────────┐
                │  Domain Object          │
                │  (User)                 │
                │ ─────────────────────   │
                │ - id: Long              │
                │ - fullName: String      │
                │ - email: String         │
                └─────────────────────────┘
                      △
                      │ maps
    ┌─────────────────┴──────────────────────────────┐
    │         Metadata Configuration                 │
    │  ────────────────────────────────────────────  │
    │  <class name="User" table="users">             │
    │    <id name="id" column="user_id"/>            │
    │    <property name="fullName"                   │
    │              column="full_name"                │
    │              type="string"/>                   │
    │    <property name="email"                      │
    │              column="email_address"            │
    │              type="string"/>                   │
    │  </class>                                      │
    └────────────────────┬───────────────────────────┘
                         │ read by
            ┌────────────▼────────────┐
            │  ORM Framework          │
            │ ─────────────────────   │
            │ + configure(metadata)   │
            │ + save(object)          │
            │ + find(id)              │
            └────────────┬────────────┘
                         │ generates
            ┌────────────▼────────────┐
            │  SQL Statements         │
            │ ─────────────────────   │
            │  INSERT INTO users...   │
            │  SELECT * FROM users... │
            └─────────────────────────┘

Alternatives: XML, Annotations, JSON, YAML, Fluent API
```

---

## Participants

- **Domain Object** (`User`): POJO (Plain Old Java Object) domain class that contains no persistence logic. It is agnostic about how it's mapped.

- **Metadata Configuration** (XML/Annotations): File or annotations that declare how object properties map to database columns, data types, relationships, loading strategies, etc.

- **ORM Framework** (Hibernate, Entity Framework): Engine that reads metadata at initialization or runtime, builds an internal mapping model, and uses this model to generate SQL and transform data.

- **Mapping Metadata Reader**: ORM component responsible for parsing XML files, reflecting annotations, or processing programmatic configurations.

- **SQL Generator**: Component that uses mapping metadata to dynamically generate SQL statements (SELECT, INSERT, UPDATE, DELETE) appropriate to the schema.

---

## Collaborations

During application initialization, the ORM Framework scans packages or configuration files, finds mapping metadata (XML files or annotations), and parses them to build an internal metamodel that describes how each class maps to tables and columns.

When the application requests `repository.save(user)`, the ORM queries the metamodel to discover that User maps to the `users` table, that `fullName` goes to the `full_name` column, etc. It then dynamically constructs the appropriate INSERT SQL, executes it, and returns the persisted object with generated ID.

---

## Consequences

### Advantages

1. **Separation of Concerns**: Domain code is clean and free of SQL/ORM persistence details.
2. **DRY**: Eliminates repetitive manual mapping code (building objects from ResultSet, filling PreparedStatements).
3. **Flexibility**: Schema changes (renaming columns, changing types) can be made by changing only metadata, not code.
4. **Database Portability**: ORM can adapt SQL for different database dialects based on metadata.
5. **Productivity**: Faster development — focus on business logic, not persistence plumbing.
6. **Declarative Strategies**: Caching, lazy loading, cascading, inheritance — all configurable via metadata.

### Disadvantages

1. **Loss of Type-Safety**: Mapping errors (wrong column name, incompatible type) are only detected at runtime, not compile-time.
2. **Learning Complexity**: Developers need to learn the ORM's DSL (XML schema, annotations) in addition to the language.
3. **Difficult Debugging**: Mapping problems generate deep, cryptic stack traces from the ORM, not from business code.
4. **Performance Overhead**: Reflection and dynamic SQL generation have computational cost compared to handcrafted SQL.
5. **Vendor Lock-in**: Metadata is often ORM-specific (Hibernate vs EF), making migration difficult.

---

## Implementation

### Implementation Considerations

1. **Format Choice**: XML is verbose but validatable with XSD; annotations are concise but pollute code; Fluent API is type-safe but requires more code. Choose based on team preferences.

2. **Metamodel Caching**: Metadata parsing is expensive. ORMs should cache the metamodel and revalidate only when configuration files change.

3. **Metadata Validation**: Implement strict metadata validation at initialization to detect errors (non-existent columns, incompatible types) before runtime.

4. **Convention over Configuration**: Minimize metadata using conventions (e.g., `name` property → `name` column). Configure only exceptions.

5. **Multi-tenant Environment**: Metadata may need to vary per tenant. Consider separate metamodels or dynamic resolution.

6. **Schema Versioning**: Include version in metadata to support migrations and controlled schema evolution.

### Implementation Techniques

1. **Annotation-Based Mapping**: Use annotations (@Entity, @Column, @OneToMany) directly on domain classes for inline configuration.

2. **External XML Mapping**: Maintain .hbm.xml (Hibernate) or .edmx (Entity Framework) files separately for complete code and config separation.

3. **Fluent Configuration**: Use fluent APIs (e.g., Entity Framework Fluent API) to configure mapping in code with type-safety.

4. **Convention-Based Mapping**: Implement standard conventions (table = plural of class, PK = Id) and override only when necessary.

5. **Composite Configurations**: Combine approaches — use annotations for simple cases, XML for complex cases (inheritance, custom queries).

6. **Code Generation**: Generate domain classes from metadata (database-first approach) or generate metadata from classes (code-first approach).

---

## Known Uses

1. **Hibernate (Java)**: The original ORM that popularized metadata mapping via .hbm.xml files (older versions) and JPA annotations (modern versions).

2. **Entity Framework (.NET)**: Supports three approaches: Database First (generates classes from schema), Code First (generates schema from classes), and Model First (visual designer generates both).

3. **Doctrine (PHP)**: Uses annotations (@ORM\Entity, @ORM\Column) or YAML/XML for entity metadata mapping.

4. **SQLAlchemy (Python)**: Supports declarative mapping via Python classes with embedded metadata or classical mapping via total separation.

5. **ActiveRecord (Ruby on Rails)**: Uses convention over configuration — mapping is implicit based on class and table names, with declarative overrides.

6. **MyBatis (Java)**: Uses XML files to map SQL statements to interface methods, giving full SQL control while keeping metadata separate.

---

## Related Patterns

- [**Data Mapper**](../data-source/004_data-mapper.md): Metadata Mapping configures how Data Mappers perform object-relational transformations.
- [**Repository**](016_repository.md): Repositories depend on metadata mapping to abstract domain object persistence.
- [**Unit of Work**](001_unit-of-work.md): Coordinates with metadata mapping to track object changes and generate persistence SQL.
- [**Identity Map**](002_identity-map.md): Uses Identity Field metadata to cache objects by primary key.
- [**Lazy Load**](003_lazy-load.md): Configured via metadata (e.g., `fetch="lazy"` in XML or `lazy: true` in annotations).
- [**Query Object**](015_query-object.md): Uses metamodel to build type-safe queries based on object structure.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Metadata declares inheritance mapping strategy (Single/Class/Concrete Table).

### Relation with Rules

- [021 - Prohibition of Logic Duplication](../../clean-code/001_prohibition-logic-duplication.md): metadata eliminates duplication
- [022 - Prioritization of Simplicity and Clarity](../../clean-code/002_prioritization-simplicity-clarity.md): declarative configuration

---

## Business Rules Relationship

- **[010] Single Responsibility Principle**: Metadata separates persistence responsibility from domain logic.
- **[014] Dependency Inversion Principle**: Domain classes don't depend on persistence details — metadata inverts the dependency.
- **[022] Prioritization of Simplicity and Clarity**: Declarative metadata can be clearer than imperative mapping code.
- **[021] Prohibition of Logic Duplication**: Eliminates duplication of manual mapping code through automatic generation based on metadata.

---

**Created on**: 2025-01-10
**Version**: 1.0
