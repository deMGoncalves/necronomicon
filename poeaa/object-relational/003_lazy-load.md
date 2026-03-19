# Lazy Load

**Classification**: Object-Relational Behavioral Pattern

---

## Intent and Purpose

An object that doesn't contain all necessary data but knows how to obtain it when needed. Defers loading of data until the moment they are actually accessed.

## Also Known As

- Lazy Initialization
- Deferred Loading
- On-Demand Loading
- Just-in-Time Loading

## Motivation

Loading a complete object with all relationships can be extremely costly. Customer may have hundreds of Orders, each Order with dozens of Items. Loading everything eagerly when you only need Customer name wastes memory and time.

Lazy Load solves this by loading only essential data initially, leaving relationships as empty "placeholders". When code accesses relationship for the first time, lazy load detects access and loads data from database at that moment. If relationship is never accessed, it's never loaded.

There are four main implementations: Lazy Initialization (check null and load), Virtual Proxy (proxy object that loads on first call), Value Holder (wrapper that encapsulates loading), and Ghost (partially loaded object that fills itself when accessed). Each has tradeoffs between transparency and complexity.

## Applicability

Use Lazy Load when:

- Objects have many relationships that are rarely used
- Loading relationships eagerly causes performance problems
- Related data is large or numerous
- N+1 query problem is acceptable or can be mitigated
- Access to relationships is predictable and controlled
- Loading transparency is not critical

## Structure

```
Client
└── Accesses: Domain Object

Domain Object
├── basicData: loaded eagerly
└── relationship: lazy (4 implementations)

1. Lazy Initialization
   └── getOrders() {
       if (orders == null) orders = loadOrders();
       return orders;
   }

2. Virtual Proxy
   └── orders: OrdersProxy
       └── First call → loads real orders

3. Value Holder
   └── orders: ValueHolder<Orders>
       └── getValue() → loads if necessary

4. Ghost
   └── Customer (partially loaded)
       └── Any access → loads missing fields
```

## Participants

- **Domain Object**: Object that has lazy data
- **Lazy Field**: Field that will be loaded on demand
- **Loader**: Responsible for loading data when necessary
- **Virtual Proxy**: Proxy object that intercepts access
- **Value Holder**: Container that encapsulates lazy loading
- **Ghost Object**: Partially initialized object
- [**Data Mapper**](../data-source/004_data-mapper.md): Loads data from database when requested

## Collaborations

**Lazy Initialization:**
- Client accesses getter method on Domain Object
- Getter checks if field is null
- If null, invokes Data Mapper to load data
- Stores loaded data and returns
- Subsequent accesses return cached data

**Virtual Proxy:**
- Domain Object contains proxy instead of real object
- Client accesses method on proxy
- Proxy intercepts call and checks if loaded
- If not loaded, proxy loads real object
- Proxy delegates call to real object

**Value Holder:**
- Domain Object contains ValueHolder
- Client calls getValue() on holder
- Holder checks if loaded and loads if necessary
- Returns value

**Ghost:**
- Object loaded with only essential fields (ID, etc)
- First access to non-loaded field triggers load
- Object loads missing fields and "materializes"

## Consequences

### Advantages

- **Initial performance**: Objects loaded more quickly
- **Memory economy**: Only necessary data in memory
- **Reduced bandwidth**: Less data transferred from database
- **Scalability**: Supports large object graphs
- **Flexibility**: Client controls what is loaded
- **Responsiveness**: More responsive UI with less waiting

### Disadvantages

- **N+1 query problem**: Can generate many small queries
- **Lost transparency**: Client may need to know about lazy load
- **Complexity**: Adds complexity to model
- **Session requirement**: Requires active session to load
- **Unexpected exceptions**: Can throw exceptions in getters
- **Difficult debugging**: Hard to track when loads happen

## Implementation

### Considerations

1. **Strategy choice**: Lazy Init, Proxy, Value Holder, or Ghost
2. **Transparency**: How much client should know about lazy loading
3. **Session management**: Keep session open for lazy loads
4. **Exception handling**: What to do when load fails
5. **Fetch strategies**: When to use eager vs lazy
6. **Batch loading**: Load multiple objects at once

### Techniques

- **Lazy Initialization**: Check null in getter and load
- **Virtual Proxy**: Create proxy that loads on first call
- **Value Holder**: Encapsulate value in holder object
- **Ghost**: Load object partially and fill later
- **Batch Fetching**: Load multiple related objects together
- **Subselect Fetching**: Use subselect to load related
- **Extra Lazy**: Operations on collections without loading all

## Known Uses

- **Hibernate**: Lazy loading of relationships and collections
- **Entity Framework**: Lazy loading via dynamic proxies
- **JPA**: Lazy fetch type default for collections
- **NHibernate**: Lazy proxy generation
- **ActiveRecord (Rails)**: Lazy queries and associations
- **Doctrine (PHP)**: Lazy loading with proxies

## Related Patterns

- [**GoF Proxy**](../../gof/structural/007_proxy.md): Virtual Proxy is Lazy Load implementation
- [**Identity Map**](002_identity-map.md): Works together; Identity Map can contain proxies
- [**Data Mapper**](../data-source/004_data-mapper.md): Mapper loads data lazily
- [**Unit of Work**](001_unit-of-work.md): Session needs to be open for lazy load
- [**Repository**](016_repository.md): Repository configures lazy loading
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Different loading strategies

### Relation to Rules

- [036 - Restriction of Functions with Side Effects](../../clean-code/016_restricao-funcoes-efeitos-colaterais.md): getter with lazy load has side effect
- [027 - Quality in Error Handling](../../clean-code/007_qualidade-tratamento-erros-dominio.md): lazy load can throw exceptions

---

**Created**: 2025-01-11
**Version**: 1.0
