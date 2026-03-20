---
titulo: Premature Optimization (Otimização Prematura)
aliases:
  - Premature Optimization
  - Otimização Prematura
tipo: anti-pattern
id: AP-10
severidade: 🟡 Médio
origem: general
tags: [anti-pattern, performance, complexidade, legibilidade]
criado: 2026-03-20
relacionados:
  - "[[clever-code]]"
  - "[[overengineering]]"
  - "[[priorizacao-simplicidade-clareza]]"
---

# Premature Optimization (Otimização Prematura)

*Premature Optimization*

---

## Definição

Otimizar código por suspeita de lentidão sem medição, antes de um problema de performance ser demonstrado. Donald Knuth: *"Premature optimization is the root of all evil."*

## Sintomas

- Algoritmos complexos onde O(n²) seria imperceptível para o volume real de dados
- Cache implementado antes de qualquer teste de performance
- Código ilegível justificado por "é mais rápido"
- Micro-otimizações em hot paths que não são hot paths
- "Vamos usar Web Workers porque pode ser lento"

## Causas Raiz

- Intuição de performance não validada por dados
- Prazer de otimizar sem medir — confunde complexidade técnica com valor
- Cultura que valoriza performance em abstrato, não na prática
- Falta de profiling antes de decidir o que otimizar

## Consequências

- Complexidade acidental: código mais difícil de ler sem ganho mensurável
- Tempo de desenvolvimento desperdiçado em otimizações desnecessárias
- Bugs introduzidos pela otimização em código que funcionava
- Manutenção mais cara: código otimizado prematuramente é difícil de mudar

## Solução / Refatoração

Seguir o ciclo: **Make it work → Make it right → Make it fast**. Otimizar apenas com evidência de problema real (profiling, métricas de produção). Medir antes e depois para confirmar o impacto.

## Exemplo — Problemático

```javascript
// ❌ Cache manual por "suspeita" de que seria lento
const _userCache = new Map();
function getUser(id) {
  if (_userCache.has(id)) return _userCache.get(id);
  const user = db.find(id);       // db já tem connection pool e query cache
  _userCache.set(id, user);        // cache sem invalidação, sem TTL, sem limite
  return user;
}

// ❌ Evitar Array.map por "ser mais lento que for loop"
// em um array de 20 elementos que roda 1x por segundo
```

## Exemplo — Refatorado

```javascript
// ✅ Simples primeiro; otimiza se profiling mostrar problema
function getUser(id) {
  return db.find(id);
}

// Após medir e confirmar que é o gargalo:
// const getUser = memoize(db.find.bind(db), { ttl: 60_000, max: 500 });
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS: legibilidade primeiro
- [[proibicao-funcionalidade-especulativa]] — YAGNI se aplica a otimizações também

## Relacionados

- [[clever-code]] — Premature Optimization frequentemente gera Clever Code
- [[overengineering]] — ambos adicionam complexidade antes da necessidade ser provada
