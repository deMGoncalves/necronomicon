# Pyramid of Doom (Arrow Anti-Pattern)

**Severidade:** 🟠 Alto
**Rule associada:** Rule 066

## O que é

Aninhamento excessivo de condicionais (`if`/`else`) e loops que cria uma estrutura visual em forma de pirâmide ou seta. Cada nível de aninhamento adiciona complexidade cognitiva e aumenta o Índice de Complexidade Ciclomática.

## Sintomas

- Código com 4 ou mais níveis de indentação
- `if` dentro de `if` dentro de `for` dentro de `if`
- Para entender o caminho feliz, precisa ler todos os níveis de aninhamento
- CC (Complexidade Ciclomática) > 10

## ❌ Exemplo (violação)

```javascript
// ❌ Pirâmide — caminho feliz enterrado no nível 4
function processOrder(order) {
  if (order) {
    if (order.items.length > 0) {
      if (order.user.isActive) {
        if (order.payment.isValid) {
          return fulfill(order); // caminho feliz no nível 4
        } else {
          return { error: 'Pagamento inválido' };
        }
      } else {
        return { error: 'Usuário inativo' };
      }
    } else {
      return { error: 'Pedido vazio' };
    }
  } else {
    return { error: 'Pedido não encontrado' };
  }
}
```

## ✅ Refatoração

```javascript
// ✅ Guard clauses — caminho feliz no nível zero
function processOrder(order) {
  if (!order) return { error: 'Pedido não encontrado' };
  if (order.items.length === 0) return { error: 'Pedido vazio' };
  if (!order.user.isActive) return { error: 'Usuário inativo' };
  if (!order.payment.isValid) return { error: 'Pagamento inválido' };

  return fulfill(order);
}
```

## Codetag sugerida

```typescript
// FIXME: Pyramid of Doom — 4 níveis de aninhamento
// TODO: Aplicar Guard Clauses para linearizar fluxo
```
