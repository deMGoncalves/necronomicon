# Adapter

**Category:** Structural
**Intent:** Convert the interface of a class into another interface that clients expect, allowing classes with incompatible interfaces to work together.

---

## When to Use

- When integrating third-party library with different interface than expected
- To use legacy code without modifying it
- When needing interoperability between components with distinct interfaces
- When encapsulating external APIs to facilitate future replacement

## When NOT to Use

- When the interface is already compatible — adding Adapter would be useless Middle Man (rule 061)
- When there are multiple deep structural incompatibilities — consider rewriting
- To mask bad design instead of fixing it

## Minimal Structure (TypeScript)

```typescript
// Interface expected by domain
interface PaymentGateway {
  charge(amount: number, currency: string): Promise<{ transactionId: string }>
}

// External API with different interface
class StripeClient {
  createCharge(params: { amount: number; currency: string; source: string }) {
    return Promise.resolve({ id: 'ch_123', status: 'succeeded' })
  }
}

// Adapter: translates domain interface to external API
class StripeAdapter implements PaymentGateway {
  constructor(private readonly stripe: StripeClient) {}

  async charge(amount: number, currency: string) {
    const result = await this.stripe.createCharge({ amount, currency, source: 'tok_visa' })
    return { transactionId: result.id }
  }
}
```

## Real Usage Example

```typescript
const gateway: PaymentGateway = new StripeAdapter(new StripeClient())
```

## Related to

- [facade.md](facade.md): complements — Facade simplifies complex interface; Adapter converts incompatible interface
- [proxy.md](proxy.md): complements — Proxy controls access; Adapter converts interface; both encapsulate another object
- [bridge.md](bridge.md): complements — Bridge separates abstraction from implementation from design; Adapter reconciles existing interfaces
- [rule 061 - Prohibition of Middle Man](../../../rules/061_proibicao-middle-man.md): reinforces — Adapter should add real conversion value, not just delegate
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): reinforces — domain depends on interface, not on external implementation

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
