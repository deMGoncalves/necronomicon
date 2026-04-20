# Transaction Script

**Camada:** Domain Logic
**Complexidade:** Simples
**Intenção:** Organizar lógica de negócio como um único procedimento que trata cada requisição da camada de apresentação.

---

## Quando Usar

- Domínio simples com poucas regras de negócio
- CRUD direto sem lógica complexa de validação ou cálculo
- Scripts de integração e sincronização de dados
- Aplicações pequenas onde complexidade de Domain Model não se justifica
- Protótipos e MVPs que precisam de velocidade de desenvolvimento

## Quando NÃO Usar

- Quando múltiplos scripts compartilham lógica semelhante (cria duplicação — rule 021)
- Quando regras de negócio ficam espalhadas por vários scripts sem coesão
- Quando o domínio tem entidades com comportamento próprio (use Domain Model)
- Quando scripts ficam com mais de 50 linhas de lógica de negócio (rule 007)

## Estrutura Mínima (TypeScript)

```typescript
// Cada função é um script completo que trata uma transação
async function createOrder(
  customerId: string,
  items: Array<{ productId: string; quantity: number }>
): Promise<string> {
  // 1. Validação simples
  if (items.length === 0) throw new Error('Pedido deve ter ao menos um item')

  // 2. Cálculo direto
  const total = items.reduce((sum, item) => sum + item.quantity * 10, 0)

  // 3. Persistência direta
  const orderId = await db.insert('orders', { customerId, total, status: 'pending' })
  await db.insertMany('order_items', items.map(item => ({ orderId, ...item })))

  return orderId
}
```

## Relacionada com

- [domain-model.md](domain-model.md): substitui quando complexidade do domínio cresce
- [row-data-gateway.md](row-data-gateway.md): complementa — Row Data Gateway é o padrão de dados natural para Transaction Script
- [active-record.md](active-record.md): complementa — Active Record é alternativa de acesso a dados para Transaction Script
- [rule 022 - Priorização de Simplicidade e Clareza](../../../rules/022_priorizacao-simplicidade-clareza.md): reforça — use quando domínio não justifica complexidade adicional

---

**PoEAA Camada:** Domain Logic
**Fonte:** Patterns of Enterprise Application Architecture — Martin Fowler (2002)
