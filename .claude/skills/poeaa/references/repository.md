# Repository

**Camada:** Data Source
**Complexidade:** Complexa
**Intenção:** Media entre o domínio e as camadas de mapeamento de dados usando interface semelhante a uma coleção para acessar objetos de domínio.

---

## Quando Usar

- Quando precisa abstrair completamente a fonte de dados do domínio
- Para facilitar troca de banco de dados ou testes com fakes
- Com Domain Model rico que não deve conhecer a fonte de dados
- Quando existem queries complexas que devem estar centralizadas

## Quando NÃO Usar

- Domínios simples com Transaction Script (overengineering — rule 064)
- Quando Active Record já é suficiente para o nível de complexidade

## Estrutura Mínima (TypeScript)

```typescript
// Interface do repositório (abstração do domínio)
interface UserRepository {
  findById(id: string): Promise<User | null>
  findByEmail(email: string): Promise<User | null>
  save(user: User): Promise<void>
  delete(id: string): Promise<void>
}

// Implementação concreta para produção
class PostgresUserRepository implements UserRepository {
  async findById(id: string): Promise<User | null> {
    const row = await this.db.query('SELECT * FROM users WHERE id = $1', [id])
    return row ? this.toDomain(row) : null
  }

  async findByEmail(email: string): Promise<User | null> {
    const row = await this.db.query('SELECT * FROM users WHERE email = $1', [email])
    return row ? this.toDomain(row) : null
  }

  async save(user: User): Promise<void> { /* upsert */ }
  async delete(id: string): Promise<void> { /* delete */ }

  private toDomain(row: Record<string, unknown>): User {
    return new User(row.id as string, row.name as string, row.email as string)
  }
}

// Fake para testes
class InMemoryUserRepository implements UserRepository {
  private readonly store = new Map<string, User>()

  async findById(id: string): Promise<User | null> { return this.store.get(id) ?? null }
  async findByEmail(email: string): Promise<User | null> {
    return [...this.store.values()].find(u => u.email === email) ?? null
  }
  async save(user: User): Promise<void> { this.store.set(user.id, user) }
  async delete(id: string): Promise<void> { this.store.delete(id) }
}
```

## Relacionada com

- [data-mapper.md](data-mapper.md): depende — Repository delega o mapeamento objeto-relacional ao Data Mapper
- [unit-of-work.md](unit-of-work.md): complementa — Unit of Work coordena commits de múltiplos repositórios atomicamente
- [identity-map.md](identity-map.md): complementa — Identity Map evita carregamentos duplicados dentro do repositório
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — isola completamente o domínio da infraestrutura de dados
- [rule 032 - Cobertura Mínima de Teste](../../../rules/032_cobertura-teste-minima-qualidade.md): complementa — interface de repositório permite substituição por fake em testes unitários

---

**PoEAA Camada:** Data Source
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
