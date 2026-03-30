# Active Record

**Camada:** Data Source
**Complexidade:** Simples
**Intenção:** Objeto que encapsula uma linha de tabela de banco de dados, encapsula o acesso ao banco de dados e adiciona lógica de domínio nos dados.

---

## Quando Usar

- Aplicações simples onde objeto de domínio = linha do banco de dados
- Quando lógica de negócio é simples e não se beneficia de isolamento do banco
- CRUDs diretos com pouca lógica adicional
- Frameworks como Rails ActiveRecord, Eloquent — onde o padrão é idiomático

## Quando NÃO Usar

- Quando o domínio tem regras complexas que não devem estar acopladas ao banco (use Data Mapper)
- Quando precisa testar domínio sem banco de dados
- Quando o esquema do banco difere significativamente do modelo de domínio

## Estrutura Mínima (TypeScript)

```typescript
class User {
  id?: number
  name: string
  email: string

  constructor(name: string, email: string) {
    this.name = name
    this.email = email
  }

  // Objeto sabe se salvar
  async save(): Promise<void> {
    if (this.id) {
      await db.execute('UPDATE users SET name=?, email=? WHERE id=?', [this.name, this.email, this.id])
    } else {
      const result = await db.execute('INSERT INTO users (name, email) VALUES (?, ?)', [this.name, this.email])
      this.id = result.insertId
    }
  }

  static async findById(id: number): Promise<User | null> {
    const rows = await db.query('SELECT * FROM users WHERE id = ?', [id])
    if (!rows[0]) return null
    const user = new User(rows[0].name, rows[0].email)
    user.id = rows[0].id
    return user
  }
}
```

## Relacionada com

- [data-mapper.md](data-mapper.md): substitui quando domínio se torna complexo e precisa ser isolado da infraestrutura
- [transaction-script.md](transaction-script.md): complementa — Active Record é a escolha natural de persistência para Transaction Script
- [row-data-gateway.md](row-data-gateway.md): substitui quando lógica de domínio cresce além de simples acesso a dados
- [rule 064 - Proibição de Overengineering](../../../rules/064_proibicao-overengineering.md): reforça — use Active Record quando Data Mapper não agrega valor real

---

**PoEAA Camada:** Data Source
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
