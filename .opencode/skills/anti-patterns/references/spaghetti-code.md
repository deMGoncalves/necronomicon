# Spaghetti Code

**Severidade:** 🔴 Crítico
**Rule associada:** Rule 060

## O que é

Código com fluxo de controle caótico e estrutura inexistente: funções que chamam outras em ordem arbitrária, estado global mutável compartilhado, responsabilidades misturadas sem separação de camadas.

## Sintomas

- Funções enormes com múltiplos níveis de aninhamento
- Estado global modificado em lugares inesperados
- Fluxo de execução que salta entre arquivos/funções sem hierarquia clara
- Impossível entender o que uma função faz sem ler tudo que ela chama
- Sem separação entre I/O, lógica de negócio e apresentação

## ❌ Exemplo (violação)

```javascript
// ❌ Lógica, I/O e apresentação misturados sem estrutura
async function handleCheckout(req, res) {
  const user = await db.query(`SELECT * FROM users WHERE id = ${req.body.userId}`);
  if (user && user.active) {
    let total = 0;
    for (let item of req.body.items) {
      const product = await db.query(`SELECT * FROM products WHERE id = ${item.id}`);
      if (product.stock > 0) {
        total += product.price * item.qty;
        await db.query(`UPDATE products SET stock = stock - ${item.qty} WHERE id = ${item.id}`);
      }
    }
    await sendEmail(user.email, `Seu pedido de R$${total} foi confirmado`);
    globalOrderCount++;
    res.json({ ok: true, total });
  } else {
    res.status(400).json({ error: 'Usuário inativo' });
  }
}
```

## ✅ Refatoração

```javascript
// ✅ Responsabilidades separadas em camadas
class CheckoutService {
  async process(userId, items) {
    const user = await this.userRepo.findActiveOrThrow(userId);
    const order = await this.orderRepo.create(user, items);
    await this.emailService.sendConfirmation(user, order);
    return order;
  }
}
```

## Codetag sugerida

```typescript
// FIXME: Spaghetti Code — I/O, validação, lógica e apresentação misturados
// TODO: Separar em layers: Controller → Service → Repository
```
