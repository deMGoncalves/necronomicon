# Singleton

**Category:** Creational
**Intent:** Ensure a class has only one instance and provide a global access point to it.

---

## When to Use

- Database connection management
- Global application configuration
- Centralized logger
- Shared in-memory cache

## When NOT to Use

- As a substitute for dependency injection — violates DIP (rule 014) and makes testing difficult
- For objects that need multiple instances with distinct states
- In concurrent systems where the single instance can become a bottleneck

## Minimal Structure (TypeScript)

```typescript
class DatabaseConnection {
  private static instance: DatabaseConnection

  // Private constructor prevents direct instantiation
  private constructor(private readonly url: string) {}

  static getInstance(url: string): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection(url)
    }
    return DatabaseConnection.instance
  }

  query(sql: string): Promise<unknown[]> {
    // execute query
    return Promise.resolve([])
  }
}
```

## Real Usage Example

```typescript
const db = DatabaseConnection.getInstance(process.env.DATABASE_URL)
```

## Related to

- [flyweight.md](flyweight.md): complements — both control instances; Flyweight for many, Singleton for one
- [factory-method.md](factory-method.md): complements — Factory Method can return the Singleton instance
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — don't use Singleton as DI substitute
- [rule 070 - Prohibition of Shared Mutable State](../../../rules/070_proibicao-estado-mutavel-compartilhado.md): reinforces — single instance with mutable state is risky

---

**GoF Category:** Creational
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
