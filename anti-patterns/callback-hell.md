---
titulo: Callback Hell (Inferno de Callbacks)
aliases:
  - Callback Hell
  - Pyramid of Doom
  - Inferno de Callbacks
tipo: anti-pattern
id: AP-22
severidade: 🟠 Alto
origem: general
tags: [anti-pattern, assincrono, legibilidade, javascript]
criado: 2026-03-20
relacionados:
  - "[[tratamento-excecao-assincrona]]"
  - "[[pyramid-of-doom]]"
  - "[[spaghetti-code]]"
---

# Callback Hell (Inferno de Callbacks)

*Callback Hell / Pyramid of Doom*

---

## Definição

Aninhamento excessivo de callbacks assíncronos que cria estrutura triangular ("pirâmide") no código. Cada operação assíncrona é passada como callback da anterior, tornando o fluxo impossível de seguir.

## Sintomas

- Indentação crescendo a cada operação assíncrona
- Tratamento de erro duplicado em cada nível do aninhamento
- Impossível ler o fluxo de cima para baixo
- Variáveis de callbacks externos usadas em callbacks internos (closure hell)

## Causas Raiz

- Uso de callbacks em vez de Promises/async-await para operações assíncronas
- Lógica sequencial expressa como aninhamento em vez de sequência
- Código legado de antes do ES2015 (Promises) e ES2017 (async/await)

## Consequências

- Legibilidade destruída: fluxo de controle impossível de rastrear
- Tratamento de erro inconsistente: cada nível precisa tratar erros separadamente
- Testabilidade zero: callbacks aninhados são impossíveis de testar em isolamento
- Reuso impossível: lógica enterrada em closures aninhadas

## Solução / Refatoração

Migrar para `async/await` com `try/catch`. Cada operação assíncrona se torna uma linha sequential. Extrair funções nomeadas para cada etapa.

## Exemplo — Problemático

```javascript
// ❌ Pyramid of doom — cada nível é uma operação assíncrona
getUser(userId, (err, user) => {
  if (err) return handleError(err);
  getOrders(user.id, (err, orders) => {
    if (err) return handleError(err);
    getProducts(orders[0].id, (err, products) => {
      if (err) return handleError(err);
      calculateTotal(products, (err, total) => {
        if (err) return handleError(err);
        sendInvoice(user, total, (err) => {
          if (err) return handleError(err);
          console.log('done');
        });
      });
    });
  });
});
```

## Exemplo — Refatorado

```javascript
// ✅ async/await — fluxo sequencial e legível
async function processInvoice(userId) {
  const user = await getUser(userId);
  const orders = await getOrders(user.id);
  const products = await getProducts(orders[0].id);
  const total = await calculateTotal(products);
  await sendInvoice(user, total);
}
```

## Rules que Previnem

- [[tratamento-excecao-assincrona]] — exige tratamento completo de exceções assíncronas

## Relacionados

- [[pyramid-of-doom]] — versão síncrona do mesmo problema (ifs/loops aninhados)
- [[spaghetti-code]] — Callback Hell é Spaghetti Code no contexto assíncrono
