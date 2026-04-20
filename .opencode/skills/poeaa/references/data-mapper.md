# Data Mapper

**Camada:** Data Source
**Complexidade:** Complexa
**Intenção:** Camada de mapeadores que move dados entre objetos e banco de dados enquanto mantém ambos independentes um do outro e do próprio mapeador.

---

## Quando Usar

- Domínio complexo com Domain Model que deve ser isolado da infraestrutura
- Quando esquema do banco difere do modelo de domínio
- Quando precisa testar domínio sem banco de dados (unit tests)
- Sistemas onde o banco pode mudar sem impactar o domínio

## Quando NÃO Usar

- Domínios simples onde Active Record seria suficiente (overengineering — rule 064)
- Quando a camada de mapeamento não adiciona valor real

## Estrutura Mínima (TypeScript)

```typescript
// Domínio puro: não sabe nada sobre banco de dados
class User {
  constructor(
    readonly id: string,
    readonly name: string,
    readonly email: string
  ) {}

  changeName(name: string): User {
    return new User(this.id, name, this.email)
  }
}

// Mapper: responsável pelo mapeamento entre domínio e banco
class UserMapper {
  async findById(id: string): Promise<User | null> {
    const row = await db.query('SELECT * FROM users WHERE id = ?', [id])
    if (!row[0]) return null
    return new User(row[0].id, row[0].name, row[0].email)
  }

  async save(user: User): Promise<void> {
    await db.execute(
      'INSERT INTO users (id, name, email) VALUES (?, ?, ?) ON CONFLICT UPDATE SET name=?, email=?',
      [user.id, user.name, user.email, user.name, user.email]
    )
  }
}
```

## Relacionada com

- [active-record.md](active-record.md): substitui quando domínio é simples e acoplamento ao banco é aceitável
- [repository.md](repository.md): complementa — Repository usa Data Mapper internamente para isolar o domínio
- [domain-model.md](domain-model.md): depende — Data Mapper é o padrão de persistência natural para Domain Model
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — mantém domínio desacoplado de infraestrutura de dados

---

**PoEAA Camada:** Data Source
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
