---
titulo: Golden Hammer (Solução Universal)
aliases:
  - Golden Hammer
  - Silver Bullet
tipo: anti-pattern
id: AP-03
severidade: 🟠 Alto
origem: antipatterns-book
tags: [anti-pattern, arquitetura, decisao-tecnica]
criado: 2026-03-20
relacionados:
  - "[[overengineering]]"
  - "[[speculative-generality]]"
---

# Golden Hammer (Solução Universal)

*Golden Hammer / Silver Bullet*

---

## Definição

Usar uma tecnologia, ferramenta ou padrão familiar para resolver todos os problemas, independente de ser a solução mais adequada. "Se a única ferramenta que você tem é um martelo, tudo parece prego." — Abraham Maslow.

## Sintomas

- O mesmo banco de dados, framework ou padrão é aplicado em contextos muito diferentes
- Decisões técnicas baseadas em familiaridade, não em adequação ao problema
- Resistência a avaliar alternativas: "já usamos X em tudo, vamos usar aqui também"
- Soluções overpowered para problemas simples (ex: Kafka para 10 mensagens/dia)

## Causas Raiz

- Zona de conforto: proficiência em uma ferramenta cria viés de confirmação
- Pressão de prazo: aprender nova ferramenta parece mais lento
- Falta de avaliação de trade-offs: nenhum processo formal de decisão técnica
- Padronização mal aplicada: "precisamos de consistência" usado como justificativa para tudo

## Consequências

- Complexidade acidental: a ferramenta errada exige workarounds
- Performance degradada: ferramenta inadequada para o volume ou padrão de acesso
- Custo operacional desnecessário: manter infraestrutura pesada para problemas leves
- Lock-in: todo o sistema depende de uma única escolha tecnológica

## Solução / Refatoração

Adotar um processo de **Architecture Decision Records (ADR)**: para cada decisão técnica relevante, documentar o problema, as alternativas consideradas e os trade-offs. Escolher a ferramenta mais simples que resolve o problema.

## Exemplo — Problemático

```javascript
// ❌ Usando Redis (cache distribuído) para armazenar config que muda 1x por semana
const config = await redis.get('app:config');
// Solução overpowered: um arquivo JSON ou variável de ambiente resolveriam

// ❌ Usando GraphQL para uma API com 2 endpoints simples
// porque "usamos GraphQL em tudo"
```

## Exemplo — Refatorado

```javascript
// ✅ Solução proporcional ao problema
import config from './config.json';

// ✅ REST simples para API simples
app.get('/users/:id', getUserHandler);
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS: use a solução mais simples que resolve o problema

## Relacionados

- [[overengineering]] — Golden Hammer frequentemente leva a overengineering
- [[speculative-generality]] — mesma raiz: decisão baseada em "e se precisarmos"
