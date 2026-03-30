# Row Data Gateway

**Camada:** Data Source
**Complexidade:** Simples
**Intenção:** Objeto que atua como gateway para um único registro retornado por um acesso ao banco de dados, com um objeto por linha e métodos de acesso ao banco.

---

## Quando Usar

- Quando se quer objeto por linha com encapsulamento de SQL
- Separar acesso ao banco de lógica de domínio de forma simples
- Alternativa mais simples ao Data Mapper para domínios moderados
- Quando Transaction Script é o padrão de domínio

## Quando NÃO Usar

- Quando o domínio é rico e objetos têm comportamento além de persistência (use Data Mapper)
- Quando o esquema do banco difere do modelo de negócio

## Estrutura Mínima (TypeScript)

```typescript
// Um objeto por linha do banco
class PersonRow {
  private id: number
  private firstName: string
  private lastName: string

  // Carregado do banco
  static async load(id: number): Promise<PersonRow> {
    const row = await db.query('SELECT * FROM person WHERE id = ?', [id])
    const person = new PersonRow()
    person.id = row.id
    person.firstName = row.first_name
    person.lastName = row.last_name
    return person
  }

  // Cada instância sabe como se atualizar
  async update(): Promise<void> {
    await db.execute(
      'UPDATE person SET first_name=?, last_name=? WHERE id=?',
      [this.firstName, this.lastName, this.id]
    )
  }

  getName(): string { return `${this.firstName} ${this.lastName}` }
}
```

## Relacionada com

- [table-data-gateway.md](table-data-gateway.md): complementa — Table Data Gateway é o finder que retorna Row Data Gateways
- [active-record.md](active-record.md): substitui quando lógica de domínio cresce e o objeto precisa de comportamento próprio
- [transaction-script.md](transaction-script.md): complementa — Row Data Gateway é o padrão de acesso a dados natural para Transaction Script

---

**PoEAA Camada:** Data Source
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
