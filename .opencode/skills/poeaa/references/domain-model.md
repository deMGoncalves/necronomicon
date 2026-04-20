# Domain Model

**Camada:** Domain Logic
**Complexidade:** Complexa
**Intenção:** Um modelo de objeto do domínio que incorpora tanto comportamento quanto dados, onde cada entidade de negócio encapsula sua própria lógica.

---

## Quando Usar

- Domínio rico com muitas regras de negócio interdependentes
- Entidades com comportamento próprio (não apenas dados)
- Regras de negócio que precisam ser testadas em isolamento
- Sistemas que devem evoluir com novos requisitos de negócio frequentemente

## Quando NÃO Usar

- Domínios simples onde Transaction Script seria suficiente (overengineering — rule 064)
- Quando a equipe não tem familiaridade com DDD e OOP avançado
- Quando tempo de entrega é crítico e o domínio é genuinamente simples

## Estrutura Mínima (TypeScript)

```typescript
class Order {
  private readonly items: OrderItem[] = []
  private status: OrderStatus = OrderStatus.PENDING

  constructor(private readonly customerId: string) {}

  addItem(product: Product, quantity: number): void {
    if (this.status !== OrderStatus.PENDING) {
      throw new Error('Não é possível adicionar itens a pedido não pendente')
    }
    this.items.push(new OrderItem(product, quantity))
  }

  confirm(): void {
    if (this.items.length === 0) throw new Error('Pedido vazio')
    this.status = OrderStatus.CONFIRMED
  }

  calculateTotal(): Money {
    return this.items.reduce(
      (total, item) => total.add(item.calculateSubtotal()),
      Money.zero()
    )
  }

  isConfirmed(): boolean { return this.status === OrderStatus.CONFIRMED }
}
```

## Relacionada com

- [transaction-script.md](transaction-script.md): substitui quando domínio é simples
- [data-mapper.md](data-mapper.md): depende — Domain Model precisa de Data Mapper para persistência sem acoplamento ao banco
- [repository.md](repository.md): depende — Repository abstrai o acesso a entidades do domínio
- [unit-of-work.md](unit-of-work.md): complementa — Unit of Work coordena a persistência de múltiplas entidades do domínio
- [rule 010 - Princípio da Responsabilidade Única](../../../rules/010_principio-responsabilidade-unica.md): reforça — cada entidade encapsula exatamente sua responsabilidade de negócio
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — domínio não depende de infraestrutura

---

**PoEAA Camada:** Domain Logic
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
