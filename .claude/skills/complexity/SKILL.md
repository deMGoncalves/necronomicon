---
name: complexity
description: Convenção para manter complexidade ciclomática dentro do limite CC ≤ 5. Use quando escrever ou refatorar métodos que possuem lógica de controle de fluxo, condicionais aninhadas ou loops — ao medir ou reduzir a complexidade ciclomática de um método.
model: haiku
allowed-tools: Read, Write, Edit, Glob, Grep
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Complexity

Convenção para manter a complexidade ciclomática (CC) de métodos dentro do limite máximo de 5.

---

## Quando Usar

Use quando escrever ou refatorar métodos que contêm estruturas de controle de fluxo (`if`, `for`, `while`, `switch`, `catch`, operador ternário `?:`).

## O que é Complexidade Ciclomática

A CC conta o número de caminhos independentes através do código. Cada estrutura de controle adiciona +1 ao total. Um método sem desvios tem CC = 1.

→ Consulte [references/cc-counting-rules.md](references/cc-counting-rules.md) para regras detalhadas de contagem.

## Limites

| CC | Status | Ação |
|----|--------|------|
| 1–5 | ✅ Dentro do limite | OK |
| 6–7 | ⚠️ Atenção | Considerar refatoração |
| 8–10 | 🟠 Alto — refatorar | Obrigatório (rule 022) |
| > 10 | 🔴 Crítico | Refatoração urgente |

→ Consulte [references/refactoring-techniques.md](references/refactoring-techniques.md) para técnicas de redução de CC.

## Exemplos

```typescript
// ❌ Ruim — CC = 7 (excede limite de 5)
function processOrder(order: Order): string {
  if (order.status === 'pending') {         // +1
    if (order.items.length > 0) {           // +1
      if (order.payment === 'card') {       // +1
        if (order.amount > 1000) {         // +1
          return applyDiscount(order)
        } else {                           // +1
          return processPayment(order)
        }
      } else if (order.payment === 'pix') { // +1
        return processPix(order)
      }
    }
  }
  return 'invalid'                          // +1
}

// ✅ Bom — CC = 2 por método (guard clauses + extração)
function processOrder(order: Order): string {
  if (!isValidOrder(order)) return 'invalid'
  return order.payment === 'pix' ? processPix(order) : processCardPayment(order)
}

function processCardPayment(order: Order): string {
  return order.amount > 1000 ? applyDiscount(order) : processPayment(order)
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| CC > 5 em qualquer método | Limite máximo da rule 022 |
| `else` ou `else if` | Usar guard clauses (rule 002) |
| Aninhamento de blocos | Manter um único nível de indentação (rule 001) |
| Método com múltiplas responsabilidades | Extrair em métodos focados (rule 010) |
| `switch` com mais de 3 cases | Substituir por mapa de funções ou polimorfismo (rule 011) |

## Fundamentação

- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): complexidade ciclomática máxima de 5 por método — critério objetivo de simplicidade
- [001 - Nível Único de Indentação](../../rules/001_nivel-unico-indentacao.md): aninhamento de blocos aumenta CC diretamente, limitando indentação controla a complexidade
- [002 - Proibição da Cláusula ELSE](../../rules/002_proibicao-clausula-else.md): cada `else if` adiciona +1 ao CC, guard clauses mantêm o fluxo linear
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): métodos com CC alto indicam múltiplas responsabilidades concentradas
- [007 - Limite Máximo de Linhas por Classe](../../rules/007_limite-maximo-linhas-classe.md): métodos com no máximo 15 linhas naturalmente limitam o espaço para estruturas de controle

**Skills relacionadas:**
- [`cdd`](../cdd/SKILL.md) — depende: CDD usa CC calculado por esta skill no componente CC_base do ICP
