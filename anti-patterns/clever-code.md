---
titulo: Clever Code (Código Inteligente)
aliases:
  - Clever Code
  - Obfuscated Code
  - Código Inteligente
tipo: anti-pattern
id: AP-09
severidade: 🟠 Alto
origem: clean-code
tags: [anti-pattern, legibilidade, complexidade, nomenclatura]
criado: 2026-03-20
relacionados:
  - "[[overengineering]]"
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[qualidade-comentarios-porque]]"
---

# Clever Code (Código Inteligente)

*Clever Code / Obfuscated Code*

---

## Definição

Código escrito para demonstrar a habilidade do autor, não para comunicar intenção. Usa truques da linguagem, expressões densas, abuso de operadores ou metaprogramação onde código direto e legível funcionaria igualmente bem.

## Sintomas

- One-liners que fazem 5 coisas ao mesmo tempo
- Abuso de operadores: `!!value`, `~~n`, `value | 0`, bitwise tricks
- Encadeamentos longos de `reduce`, `flatMap` e `map` aninhados
- Variáveis de uma letra fora de contextos matemáticos
- Comentário `// don't touch this` sem explicação do porquê

## Causas Raiz

- Viés de impressionar: código que "parece inteligente" é visto como sinal de senioridade
- Otimização prematura: tricks de performance sem evidência de necessidade
- Cultura que valoriza concisão acima de legibilidade
- Cópia de snippets de Stack Overflow sem entender o que fazem

## Consequências

- Leitura lenta: qualquer manutenção exige decodificar o que o código faz
- Bugs ocultos: código denso esconde edge cases
- Revisão de código ineficaz: reviewer aprova sem entender completamente
- Barrier de entrada: juniors não conseguem contribuir com segurança

## Solução / Refatoração

Reescrever com clareza como critério principal. Nomear variáveis intermediárias para documentar o que cada etapa faz. Regra: se precisar de mais de 5 segundos para entender, está errado.

## Exemplo — Problemático

```javascript
// ❌ "Inteligente" — o que isso faz?
const getDiscount = (u) =>
  u?.premium && u?.purchases > 10 ? (u?.vip ? 0.3 : 0.2) : u?.purchases > 5 ? 0.1 : 0;

// ❌ Trick bitwise para truncar número
const n = value | 0;

// ❌ Coerção implícita como lógica
const display = user.name || user.email || user.id + '';
```

## Exemplo — Refatorado

```javascript
// ✅ Legível — intenção clara em cada linha
function getDiscount(user) {
  if (!user) return 0;
  if (user.premium && user.vip && user.purchases > 10) return 0.3;
  if (user.premium && user.purchases > 10) return 0.2;
  if (user.purchases > 5) return 0.1;
  return 0;
}

// ✅ Intenção explícita
const n = Math.trunc(value);
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS: clareza acima de esperteza
- [[nomes-classes-metodos-consistentes]] — nomes revelam intenção

## Relacionados

- [[overengineering]] — Clever Code é Overengineering no nível de expressão
- [[pyramid-of-doom]] — ternários aninhados são Clever Code + Pyramid of Doom
