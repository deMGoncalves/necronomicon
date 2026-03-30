# Adapter

**Categoria:** Estrutural
**Intenção:** Converter a interface de uma classe em outra interface que os clientes esperam, permitindo que classes com interfaces incompatíveis trabalhem juntas.

---

## Quando Usar

- Ao integrar biblioteca de terceiros com interface diferente da esperada
- Para usar código legado sem modificá-lo
- Quando precisa de interoperabilidade entre componentes com interfaces distintas
- Ao encapsular APIs externas para facilitar substituição futura

## Quando NÃO Usar

- Quando a interface já é compatível — adicionar Adapter seria Middle Man inútil (rule 061)
- Quando há múltiplas incompatibilidades estruturais profundas — considerar reescrever
- Para mascarar design ruim em vez de corrigi-lo

## Estrutura Mínima (TypeScript)

```typescript
// Interface esperada pelo domínio
interface PaymentGateway {
  charge(amount: number, currency: string): Promise<{ transactionId: string }>
}

// API externa com interface diferente
class StripeClient {
  createCharge(params: { amount: number; currency: string; source: string }) {
    return Promise.resolve({ id: 'ch_123', status: 'succeeded' })
  }
}

// Adapter: traduz interface do domínio para API externa
class StripeAdapter implements PaymentGateway {
  constructor(private readonly stripe: StripeClient) {}

  async charge(amount: number, currency: string) {
    const result = await this.stripe.createCharge({ amount, currency, source: 'tok_visa' })
    return { transactionId: result.id }
  }
}
```

## Exemplo de Uso Real

```typescript
const gateway: PaymentGateway = new StripeAdapter(new StripeClient())
```

## Relacionada com

- [facade.md](facade.md): complementa — Facade simplifica interface complexa; Adapter converte interface incompatível
- [proxy.md](proxy.md): complementa — Proxy controla acesso; Adapter converte interface; ambos encapsulam outro objeto
- [bridge.md](bridge.md): complementa — Bridge separa abstração de implementação desde o design; Adapter reconcilia interfaces existentes
- [rule 061 - Proibição de Middle Man](../../../rules/061_proibicao-middle-man.md): reforça — Adapter deve adicionar valor real de conversão, não apenas delegar
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — domínio depende da interface, não da implementação externa

---

**GoF Categoria:** Structural
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
