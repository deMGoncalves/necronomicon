---
titulo: Pyramid of Doom (Pirâmide da Perdição)
aliases:
  - Pyramid of Doom
  - Arrow Anti-Pattern
  - Pirâmide da Perdição
tipo: anti-pattern
id: AP-23
severidade: 🟠 Alto
origem: general
tags: [anti-pattern, estrutural, legibilidade, complexidade]
criado: 2026-03-20
relacionados:
  - "[[callback-hell]]"
  - "[[002_prohibition-else-clause]]"
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[spaghetti-code]]"
---

# Pyramid of Doom (Pirâmide da Perdição)

*Pyramid of Doom / Arrow Anti-Pattern*

---

## Definição

Aninhamento excessivo de condicionais (`if`/`else`) e loops que cria uma estrutura visual em forma de pirâmide ou seta. Cada nível de aninhamento adiciona complexidade cognitiva e aumenta o Índice de Complexidade Ciclomática.

## Sintomas

- Código com 4 ou mais níveis de indentação
- `if` dentro de `if` dentro de `for` dentro de `if`
- Para entender o caminho feliz, precisa ler todos os níveis de aninhamento
- CC (Complexidade Ciclomática) > 10

## Causas Raiz

- Validações cumulativas sem early return
- Lógica de guard misturada com lógica de negócio
- Loops com condicionais complexas dentro em vez de funções extraídas

## Consequências

- Leitura não linear: impossível entender o fluxo de cima para baixo
- Bugs em edge cases: caminhos internos raramente testados
- Dificuldade de adicionar novas condições: cada adição aumenta o aninhamento

## Solução / Refatoração

Usar **Early Return / Guard Clauses**: inverter as condições negativas e retornar cedo, mantendo o caminho feliz no nível zero de aninhamento. Extrair loops internos em funções nomeadas.

## Exemplo — Problemático

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

## Exemplo — Refatorado

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

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — CC ≤ 5, aninhamento mínimo
- [[002_prohibition-else-clause]] — proibição de else evita aninhamento desnecessário
- [[001_single-indentation-level]] — nível único de indentação (Object Calisthenics)

## Relacionados

- [[callback-hell]] — versão assíncrona da Pyramid of Doom
- [[spaghetti-code]] — Pyramid of Doom é frequentemente um sintoma de Spaghetti Code
