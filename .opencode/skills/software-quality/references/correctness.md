# Correctness — Corretude

**Dimensão:** Operação
**Severidade Default:** 🔴 Crítica
**Pergunta Chave:** Ele faz o que é pedido?

## O que é

O grau em que o software cumpre suas especificações e atende aos objetivos do usuário. Um software correto produz os resultados esperados para todas as entradas válidas e trata adequadamente os casos de borda.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Bug afeta dados do usuário | 🔴 Blocker |
| Bug afeta cálculos críticos (financeiro) | 🔴 Blocker |
| Bug em edge case raro | 🟠 Important |
| Bug cosmético em UI | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Incorreto - não considera edge cases
function calculateDiscount(price, quantity) {
  return price * quantity * 0.1; // E se quantity for 0 ou negativo?
}

// ✅ Correto - trata edge cases
function calculateDiscount(price, quantity) {
  if (quantity <= 0) return 0;
  if (price <= 0) return 0;
  return price * quantity * 0.1;
}
```

## Codetags Sugeridos

```javascript
// FIXME: Division by zero quando items está vazio
// BUG: Comparação incorreta entre tipos — usar ===
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Bug afeta dados do usuário | 🔴 Blocker |
| Bug afeta cálculos críticos | 🔴 Blocker |
| Bug em edge case raro | 🟠 Important |
| Bug cosmético | 🟡 Suggestion |

## Rules Relacionadas

- 027 - Qualidade no Tratamento de Erros de Domínio
- 028 - Tratamento de Exceção Assíncrona
- 002 - Proibição da Cláusula ELSE
