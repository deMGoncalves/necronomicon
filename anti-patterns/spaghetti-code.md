---
titulo: Spaghetti Code (Código Espaguete)
aliases:
  - Spaghetti Code
  - Código Espaguete
tipo: anti-pattern
id: AP-04
severidade: 🔴 Crítico
origem: antipatterns-book
tags: [anti-pattern, estrutural, complexidade, legibilidade]
criado: 2026-03-20
relacionados:
  - "[[the-blob]]"
  - "[[pyramid-of-doom]]"
  - "[[priorizacao-simplicidade-clareza]]"
---

# Spaghetti Code (Código Espaguete)

*Spaghetti Code*

---

## Definição

Código com fluxo de controle caótico e estrutura inexistente: funções que chamam outras em ordem arbitrária, estado global mutável compartilhado, responsabilidades misturadas sem separação de camadas. Impossível de seguir de cima para baixo.

## Sintomas

- Funções enormes com múltiplos níveis de aninhamento
- Estado global modificado em lugares inesperados
- Fluxo de execução que salta entre arquivos/funções sem hierarquia clara
- Impossível entender o que uma função faz sem ler tudo que ela chama
- Sem separação entre I/O, lógica de negócio e apresentação

## Causas Raiz

- Ausência de design prévio: código cresceu organicamente sem arquitetura
- Adição de features sem refatoração: "só adiciono aqui no meio"
- Programador procedural em ambiente OO: pensa em passos, não em responsabilidades
- Correções de bug por patches: cada bug resolvido com um `if` extra

## Consequências

- Impossível testar: efeitos colaterais em todo lugar
- Bugs invisíveis: mudança em um ponto quebra algo distante
- Tempo de onboarding alto: horas para entender o fluxo de um caso de uso simples
- Refatoração bloqueada: medo de quebrar o que "funciona"

## Solução / Refatoração

Aplicar separação de camadas (MVC, Clean Architecture), extrair funções com responsabilidade única, eliminar estado global. Começar pela cobertura de testes antes de refatorar para garantir segurança.

## Exemplo — Problemático

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

## Exemplo — Refatorado

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

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS exige estrutura clara
- [[restricao-funcoes-efeitos-colaterais]] — proíbe efeitos colaterais ocultos
- [[001_single-responsibility-principle]] — cada função com um propósito

## Relacionados

- [[the-blob]] — Spaghetti Code frequentemente está dentro de um Blob
- [[pyramid-of-doom]] — aninhamento excessivo é sintoma de Spaghetti Code
- [[callback-hell]] — versão assíncrona do Spaghetti Code
