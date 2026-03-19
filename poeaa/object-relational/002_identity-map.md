# Identity Map

**Classification**: Object-Relational Behavioral Pattern

---

## Intent and Purpose

Ensures that each object is loaded only once by keeping every loaded object in a map. Looks up objects using the map to avoid duplicates and ensure only one instance of an object with a given ID exists in memory.

## Also Known As

- Object Cache
- Session Cache
- First-Level Cache

## Motivation

When you load an object from database multiple times in the same session, without Identity Map you'll have multiple copies in memory. This causes problems: changes in one copy don't appear in another, identity comparisons fail, and conflicting updates can corrupt data.

Identity Map solves this by maintaining a map of already-loaded objects, indexed by ID. When code requests an object by ID, Identity Map first checks map. If object is already there, returns existing reference. If not, loads from database, adds to map, and returns. This ensures only one instance of object with given ID exists in session.

For example, if you load Person(5) twice, without Identity Map you'd have two different instances. With Identity Map, both requests return the same instance. Changes made via one reference are visible through the other because it's the same object. This maintains consistency and avoids subtle state problems.

## Applicability

Use Identity Map when:

- Same objects are accessed multiple times in a session
- Object identity (reference) needs to be preserved
- Session or Unit of Work is in use
- Performance of repeated reads needs to be optimized
- State consistency within session is critical
- Multiple queries may return the same objects

## Structure

```
Client
└── Uses: Repository or Data Mapper

Repository/Data Mapper
└── Queries: Identity Map

Identity Map
├── map: Map<ID, Object>
├── get(id): Object
│   └── If exists: return cached
│   └── If not: load from DB, cache, return
├── add(id, object)
└── remove(id)

Flow:
1. Client requests Person(5)
2. Mapper queries IdentityMap.get(5)
3. If Person(5) already in map → returns cached
4. If not → loads from DB
5. Adds to map via IdentityMap.add(5, person)
6. Returns person
7. Next call for Person(5) → returns from map
```

## Participants

- [**Identity Map**](002_identity-map.md): Map maintaining loaded objects indexed by ID
- **Object Key**: ID or compound key used to identify object
- **Cached Object**: Object stored in map
- **Data Mapper/Repository**: Uses Identity Map to ensure identity
- **Session**: Lifetime scope of Identity Map (usually per session/request)

## Collaborations

- Client requests object via Repository or Data Mapper
- Mapper checks Identity Map first using object ID
- If object is in map, Mapper returns cached reference
- If object not in map, Mapper loads from database
- Mapper adds newly loaded object to Identity Map
- Mapper returns object to Client
- Any subsequent request for same ID returns same instance
- When session ends, Identity Map is discarded

## Consequences

### Advantages

- **Identity guaranteed**: Only one instance per ID in session
- **Performance**: Avoids repeated queries for same data
- **Consistency**: Changes visible through all references
- **Automatic cache**: First-level cache transparent
- **Simplicity**: Client doesn't need to manage cache manually
- **Prevents aliasing bugs**: Avoids problems of multiple copies

### Disadvantages

- **Memory overhead**: Keeps all loaded objects in memory
- **Lifecycle management**: Needs to clear map when session ends
- **Concurrency**: Can hide changes made by other sessions
- **Complexity**: Adds cache management layer
- **Memory leaks**: If not cleaned properly can cause leaks
- **Stale data**: Cached data can become outdated

## Implementation

### Considerations

1. **Map scope**: Usually per session/request; not global
2. **Key type**: Simple ID or compound key (class + ID)
3. **Cleanup**: When and how to clear the map
4. **Thread safety**: If needed for concurrent access
5. **Weak references**: Use to allow GC of unused objects
6. **Multiple maps**: One map per entity type vs single map

### Techniques

- **Simple Map**: Use native Map/HashMap structure
- **Per-Type Maps**: Separate map for each entity type
- **Weak References**: Allow garbage collection if memory is problem
- **Session Scope**: Associate map with session or Unit of Work
- **Key Strategy**: Use class + ID as compound key
- **Clear on Close**: Clear map when session closes

## Known Uses

- **Hibernate Session**: First-level cache is Identity Map
- **Entity Framework Context**: Change tracker is Identity Map
- **JPA EntityManager**: Persistence context is Identity Map
- **NHibernate Session**: Session cache
- **SQLAlchemy Session**: Identity map built-in
- **TypeORM EntityManager**: Maintains identity map

## Related Patterns

- [**Unit of Work**](001_unit-of-work.md): Works together; UoW uses Identity Map
- [**Data Mapper**](../data-source/004_data-mapper.md): Mapper queries Identity Map
- [**Repository**](016_repository.md): Repository uses Identity Map internally
- [**Lazy Load**](003_lazy-load.md): Identity Map can contain lazy proxies
- [**GoF Flyweight**](../../gof/structural/006_flyweight.md): Similar; shares objects
- **Second Level Cache**: Identity Map is first-level cache

### Relation to Rules

- [029 - Object Immutability](../../clean-code/009_imutabilidade-objetos-freeze.md): Identity Map with immutables is thread-safe
- [045 - Stateless Processes](../../twelve-factor/006_processos-stateless.md): Identity Map is state; scope per request

---

**Created**: 2025-01-11
**Version**: 1.0
