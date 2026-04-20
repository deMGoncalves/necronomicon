# Lazy Load

**Camada:** Object-Relational
**Complexidade:** Moderada
**Intenção:** Um objeto que não contém todos os dados que necessita, mas sabe como obtê-los — o carregamento ocorre apenas quando os dados são realmente acessados.

---

## Quando Usar

- Relações grandes que raramente são acessadas
- Quando carregar todos os dados de uma vez seria muito custoso
- Em objetos de domínio com associações que nem sempre são necessárias
- Para otimizar tempo de carregamento em queries com muitas relações

## Quando NÃO Usar

- Quando os dados sempre serão necessários (carregue junto — Eager Loading)
- Quando o overhead de queries adicionais é pior que carregar tudo de uma vez (N+1 problem)
- Em loops onde Lazy Load causaria N+1 queries (use Eager Loading com JOIN)

## Estrutura Mínima (TypeScript)

```typescript
class Customer {
  private _orders: Order[] | null = null

  constructor(
    readonly id: string,
    readonly name: string,
    private readonly orderRepository: OrderRepository
  ) {}

  // Lazy Load: carrega pedidos apenas quando acessados
  async getOrders(): Promise<Order[]> {
    if (!this._orders) {
      this._orders = await this.orderRepository.findByCustomerId(this.id)
    }
    return this._orders
  }
}

// Alternativa com Virtual Proxy
class LazyOrderCollection {
  private loaded = false
  private orders: Order[] = []

  constructor(
    private readonly customerId: string,
    private readonly repository: OrderRepository
  ) {}

  async toArray(): Promise<Order[]> {
    if (!this.loaded) {
      this.orders = await this.repository.findByCustomerId(this.customerId)
      this.loaded = true
    }
    return this.orders
  }
}
```

## Relacionada com

- [identity-map.md](identity-map.md): complementa — Identity Map evita carregamentos duplicados quando Lazy Load é acionado múltiplas vezes
- [rule 069 - Proibição de Otimização Prematura](../../../rules/069_proibicao-otimizacao-prematura.md): reforça — medir antes de introduzir Lazy Load; pode criar N+1 se usado sem critério

---

**PoEAA Camada:** Object-Relational
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
