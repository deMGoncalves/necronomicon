---
name: poeaa
description: Referência dos principais Patterns of Enterprise Application Architecture (PoEAA) de Martin Fowler. Use quando @architect precisa projetar camadas de domínio, persistência ou apresentação em aplicações JavaScript/TypeScript enterprise — ao escolher entre Active Record, Data Mapper, Repository, Unit of Work.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "2.0.0"
  category: design-patterns
---

# PoEAA — Patterns of Enterprise Application Architecture

Padrões para aplicações enterprise organizados por camada arquitetural.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao projetar camadas de domínio, persistência ou apresentação em aplicações enterprise; ao decidir entre Transaction Script vs Domain Model; ao decidir entre Active Record vs Data Mapper vs Repository |
| **Prerequisites** | Skill `gof` (PoEAA usa GoF internamente); principles SOLID (rules 010–014); conceitos de separação de camadas (domain vs infrastructure) |
| **Constraints** | Transaction Script apenas quando domínio não justifica complexidade (rule 022 KISS); Active Record viola DIP (rule 014) — usar apenas para domínios simples sem regras de negócio complexas |
| **Scope** | 15 padrões principais organizados por camada: Lógica de Domínio, Fonte de Dados, Objeto-Relacional e Apresentação Web |

---

## Quando Usar

- @architect: Fase de research para projetar camadas de domínio e persistência
- Ao decidir: Transaction Script vs Domain Model?
- Ao decidir: Active Record vs Data Mapper vs Repository?
- @coder: ao implementar camadas de service e repository

## Padrões por Camada

| Camada | Padrão | Complexidade | Referência |
|--------|--------|--------------|------------|
| Lógica de Domínio | Transaction Script | Simples | [transaction-script.md](references/transaction-script.md) |
| Lógica de Domínio | Domain Model | Complexa | [domain-model.md](references/domain-model.md) |
| Lógica de Domínio | Table Module | Moderada | [table-module.md](references/table-module.md) |
| Fonte de Dados | Active Record | Simples | [active-record.md](references/active-record.md) |
| Fonte de Dados | Data Mapper | Complexa | [data-mapper.md](references/data-mapper.md) |
| Fonte de Dados | Repository | Complexa | [repository.md](references/repository.md) |
| Fonte de Dados | Table Data Gateway | Simples | [table-data-gateway.md](references/table-data-gateway.md) |
| Fonte de Dados | Row Data Gateway | Simples | [row-data-gateway.md](references/row-data-gateway.md) |
| Objeto-Relacional | Unit of Work | Moderada | [unit-of-work.md](references/unit-of-work.md) |
| Objeto-Relacional | Identity Map | Moderada | [identity-map.md](references/identity-map.md) |
| Objeto-Relacional | Lazy Load | Moderada | [lazy-load.md](references/lazy-load.md) |
| Apresentação Web | MVC | Moderada | [mvc.md](references/mvc.md) |
| Apresentação Web | Front Controller | Moderada | [front-controller.md](references/front-controller.md) |
| Apresentação Web | Page Controller | Simples | [page-controller.md](references/page-controller.md) |
| Apresentação Web | Application Controller | Complexa | [application-controller.md](references/application-controller.md) |

## Decisão Rápida

| Complexidade do Domínio | Padrão Recomendado |
|-------------------------|--------------------|
| Simples, poucas regras | Transaction Script |
| Moderada | Table Module |
| Rica, muitas regras | Domain Model |

| Acesso a Dados | Padrão Recomendado |
|-----------------|---------------------|
| Simples, objeto = linha do DB | Active Record |
| Domínio complexo, isolado do DB | Data Mapper + Repository |
| Múltiplas operações atômicas | Unit of Work |

## Exemplos

```typescript
// ❌ Ruim — Active Record: domínio acoplado à persistência
class User extends ActiveRecord {
  name: string
  async save() { await db.query('INSERT INTO users...') }  // lógica de negócio + DB misturados
  async validate() { return this.name.length > 0 }  // regras de negócio em classe de persistência
}

// ✅ Bom — Data Mapper: separação entre domínio e persistência
class User {  // Domínio puro, não sabe de DB
  constructor(public name: string) {}
  validateName() { return this.name.length > 0 }  // lógica de negócio isolada
}
class UserMapper {  // Responsável pela persistência
  async save(user: User) { await db.query('INSERT INTO users...') }
  async findById(id: string): Promise<User> { /* ... */ }
}
```

```typescript
// ❌ Ruim — Transaction Script: lógica de negócio espalhada
async function transferMoney(fromId: string, toId: string, amount: number) {
  const from = await db.query('SELECT * FROM accounts WHERE id = ?', [fromId])
  const to = await db.query('SELECT * FROM accounts WHERE id = ?', [toId])
  if (from.balance < amount) throw new Error('Insufficient funds')
  await db.query('UPDATE accounts SET balance = balance - ? WHERE id = ?', [amount, fromId])
  await db.query('UPDATE accounts SET balance = balance + ? WHERE id = ?', [amount, toId])
  // difícil de testar, validações misturadas com persistência
}

// ✅ Bom — Domain Model + Repository: domínio rico e testável
class Account {
  constructor(public id: string, private balance: number) {}
  withdraw(amount: number) {
    if (this.balance < amount) throw new InsufficientFundsError()
    this.balance -= amount
  }
  deposit(amount: number) { this.balance += amount }
}
class TransferService {
  constructor(private repo: AccountRepository) {}
  async transfer(fromId: string, toId: string, amount: number) {
    const from = await this.repo.findById(fromId)
    const to = await this.repo.findById(toId)
    from.withdraw(amount)  // lógica de negócio no domínio
    to.deposit(amount)
    await this.repo.save(from)
    await this.repo.save(to)
  }
}
// testável isoladamente sem DB
```

## Justificativa

- rule 010 (SRP): Domain Model garante que cada classe tem responsabilidade única
- rule 014 (DIP): Repository isola domínio da infraestrutura de dados
- rule 021 (DRY): Unit of Work centraliza persistência
- rule 022 (KISS): Transaction Script quando domínio não justifica complexidade

**Skills relacionadas:**
- [`gof`](../gof/SKILL.md) — depende: PoEAA usa GoF internamente (Strategy, Repository, Observer)
- [`solid`](../solid/SKILL.md) — reforça: PoEAA implementa DIP via Data Mapper e Repository
