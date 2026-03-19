# Inheritance Mappers

**Type**: Object-Relational Mapping Pattern (Structural)

---

## Intent and Purpose

Structure Data Mappers in a way that reflects the inheritance hierarchy of the domain objects being mapped, allowing reuse of common mapping code through Mapper inheritance.

## Also Known As

- Hierarchical Mappers
- Mapper Inheritance
- Layered Mappers

---

## Motivation

When using the Data Mapper pattern with a hierarchy of domain objects (e.g., Animal → Dog, Cat), the question arises of how to structure the Mappers. One approach would be to create completely independent Mappers for each class, but this would lead to massive code duplication — every Mapper would repeat the logic for mapping common fields (id, name) defined in the Animal superclass.

Inheritance Mappers solves this problem by making the Mappers mirror the domain's inheritance hierarchy: create an `AbstractAnimalMapper` that knows how to map common fields, and then `DogMapper` and `CatMapper` inherit from it, adding only the code to map their specific fields. This maximizes reuse and maintains DRY.

The pattern works with any inheritance mapping strategy (Single Table, Class Table, Concrete Table). For example, with Class Table Inheritance, the `AbstractAnimalMapper` maps the `animals` table, and `DogMapper` inherits and adds logic to JOIN and map the `dogs` table. The Mapper inheritance structure decouples mapping logic from schema strategy.

---

## Applicability

Use Inheritance Mappers when:

- You are using the Data Mapper pattern (not Active Record) with object hierarchies
- Classes in the hierarchy share common fields that would be duplicated if each Mapper were independent
- Mapping logic (queries, transformations) has common parts that can be abstracted
- You want changes in the domain superclass to automatically reflect in all subclass Mappers
- The domain hierarchy is stable — inheritance refactorings are rare
- You want to keep mapping logic organized in a way that reflects the domain structure

---

## Structure

```
Domain Layer:
┌──────────────────────────────────────────────────────────┐
│                    <<abstract>>                          │
│                       Animal                             │
│ ──────────────────────────────────────────────────────   │
│ - id: Long                                               │
│ - name: String                                           │
└────────────────────────┬─────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
┌─────────▼──────────┐        ┌─────────▼──────────┐
│   Dog              │        │   Cat              │
│ ────────────────   │        │ ────────────────   │
│ - breed: String    │        │ - furColor: String │
└────────────────────┘        └────────────────────┘

Mapper Layer:
┌──────────────────────────────────────────────────────────┐
│             <<abstract>>                                 │
│          AbstractAnimalMapper                            │
│ ──────────────────────────────────────────────────────   │
│ # mapCommonFields(rs: ResultSet, animal: Animal)         │
│ # insertCommonFields(animal: Animal): Long               │
│ + find(id: Long): Animal  {abstract}                     │
└────────────────────────┬─────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
┌─────────▼──────────┐        ┌─────────▼──────────┐
│  DogMapper         │        │  CatMapper         │
│ ────────────────   │        │ ────────────────   │
│ + find(id): Dog    │        │ + find(id): Cat    │
│ + insert(d: Dog)   │        │ + insert(c: Cat)   │
│ - mapBreed(rs)     │        │ - mapColor(rs)     │
└────────────────────┘        └────────────────────┘
```

---

## Participants

- **AbstractAnimalMapper** (Abstract Base Mapper): Contains shared logic for mapping common fields (id, name). May have template methods that define the general flow of find/insert/update, leaving details to subclasses.

- **DogMapper / CatMapper** (Concrete Mappers): Inherit from the base Mapper and implement specific logic for mapping additional fields (breed, furColor). Can call protected methods from the superclass.

- **Domain Objects** (Animal, Dog, Cat): The domain objects being mapped. The Mapper hierarchy mirrors the domain hierarchy.

- **Database Schema**: Can use any strategy (Single Table, Class Table, Concrete Table). The Inheritance Mappers pattern is independent of schema strategy.

- **Template Methods**: Methods in the Mapper superclass that define the skeleton of the mapping algorithm, delegating specific steps to subclasses.

---

## Collaborations

When the client requests `dogMapper.find(id)`, the DogMapper executes the specific query (which may include JOIN if using Class Table). When constructing the Dog object from the ResultSet, it calls `mapCommonFields(rs, dog)` inherited from AbstractAnimalMapper to populate id and name, then adds its own logic to populate breed.

In the insert operation, DogMapper first calls `super.insertCommonFields(dog)` which inserts into the `animals` table and returns the generated ID. Then, it uses this ID to insert into the `dogs` table with specific fields. The flow is coordinated by Mapper inheritance.

---

## Consequences

### Advantages

1. **Code Reuse**: Mapping logic for common fields is written once in the Mapper superclass.
2. **DRY in Mapping**: Avoids duplication of mapping code between subclass Mappers.
3. **Maintainability**: Changes to superclass domain fields require changes only in the base Mapper.
4. **Clear Structure**: The Mapper hierarchy mirrors the domain, facilitating navigation and understanding.
5. [**Template Method**](../../gof/behavioral/010_template-method.md): Allows defining complex mapping flows in the superclass with hooks for subclasses.
6. **Schema Flexibility**: Works with any schema inheritance strategy (Single/Class/Concrete Table).

### Disadvantages

1. **Inheritance Coupling**: Mappers become tightly coupled to the domain hierarchy — inheritance refactorings require changes to Mappers.
2. **Debug Complexity**: Execution flow crosses multiple inheritance levels, making debugging difficult.
3. **Base Class Fragility**: Changes to AbstractMapper can break all subclass Mappers.
4. **Language Limitations**: In languages without multiple inheritance, Mappers cannot inherit from multiple sources if needed.
5. **Testing Difficulty**: Testing concrete Mappers requires setup of base Mappers, increasing test complexity.

---

## Implementation

### Implementation Considerations

1. **Protected Methods**: Use `protected` visibility for auxiliary mapping methods that should be accessible by subclasses but not by clients.

2. **Template Method Pattern**: Structure main methods (find, insert) as templates in the superclass with hooks (abstract methods) for subclasses to fill in.

3. **Superclass Initialization**: Concrete Mapper constructors must call superclass constructors to ensure proper initialization (e.g., connection pool).

4. **Shared Identity Map**: If using Identity Map, share an instance between Mappers in the hierarchy to avoid multiple instances of the same object.

5. **Exception Handling**: Centralize database exception handling in the Mapper superclass when possible.

6. **Dependency Injection**: Inject dependencies (DataSource, connections) into the base Mapper and propagate to subclasses.

### Implementation Techniques

1. **Abstract Find Method**: Define `find(id)` as abstract in the base Mapper, forcing each concrete Mapper to implement its own query.

2. **Protected Field Mappers**: Create methods like `protected void mapId(ResultSet rs, Animal animal)` in the superclass to be reused.

3. **Strategy for Schema**: Use Strategy pattern for schema-specific logic (Single Table vs Class Table), keeping Mappers independent of strategy.

4. **Lazy Initialization**: Concrete Mappers can use lazy initialization to create instances of related Mappers (e.g., address) only when needed.

5. **Reflection for Instantiation**: Use reflection in the superclass to instantiate domain objects of the correct type, avoiding duplication of instantiation code.

6. **Query Builders**: Encapsulate query construction in helper methods in the superclass (e.g., `buildSelectCommonFields()`) that subclasses can extend.

---

## Known Uses

1. **MyBatis Mapper Inheritance**: MyBatis allows XML mappers to inherit from base mappers, reusing common SQL fragments.

2. **Custom ORMs in Corporate Systems**: Large financial systems frequently implement Inheritance Mappers for Financial Instrument hierarchies.

3. **Rails + Repository Pattern**: Rails applications using Repository instead of Active Record frequently implement hierarchical repositories.

4. **Java Persistence Frameworks**: Frameworks like iBatis and early Hibernate encouraged structuring Mappers in hierarchies.

5. **Entity Framework Migrations**: EF migrations can be structured in a hierarchy to share base migrations.

6. **Doctrine ORM (PHP)**: Supports hierarchical mapping where child entity mappers reference parent mapper configurations.

---

## Related Patterns

- [**Data Mapper**](../data-source/004_data-mapper.md): Inheritance Mappers is a specialization of Data Mapper for object hierarchies.
- [**GoF Template Method**](../../gof/behavioral/010_template-method.md): Used extensively to define skeleton of mapping algorithms in the Mapper superclass.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Can complement to switch schema strategies (Single/Class/Concrete Table) without changing Mappers.
- [**Layer Supertype**](../base/003_layer-supertype.md): AbstractMapper is a Layer Supertype for all Mappers in the application.
- [**Single Table Inheritance**](010_single-table-inheritance.md): Inheritance Mappers works well with STI — superclass maps single table and discriminator.
- [**Class Table Inheritance**](011_class-table-inheritance.md): Mappers inherit and add JOIN logic to map subclass tables.
- [**Registry**](../base/005_registry.md): Mappers can be registered in a Registry for dynamic lookup by domain type.

### Relation with Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): abstract mappers
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): one mapper per hierarchy

---

## Business Rules Relationship

- **[021] Prohibition of Logic Duplication**: Inheritance Mappers eliminates duplication of common field mapping logic.
- **[010] Single Responsibility Principle**: Each Mapper has the single responsibility of mapping its domain class.
- **[014] Dependency Inversion Principle**: Abstract Mappers depend on abstractions (interfaces), not concrete Mappers.
- **[022] Prioritization of Simplicity and Clarity**: Clear hierarchical structure reflects and documents the domain.

---

**Created on**: 2025-01-10
**Version**: 1.0
