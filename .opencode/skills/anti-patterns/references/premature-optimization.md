# Premature Optimization (Otimização Prematura)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 069

## O que é

Otimizar código por suspeita de lentidão sem medição, antes de um problema de performance ser demonstrado. Donald Knuth: *"Premature optimization is the root of all evil."*

## Sintomas

- Otimização implementada sem medição prévia (profiling, benchmark, métricas de produção)
- Algoritmos complexos onde O(n²) seria imperceptível para o volume real de dados
- Cache implementado antes de qualquer teste de performance
- Código ilegível justificado por "é mais rápido"
- Micro-otimizações em hot paths que não são hot paths (ex: `for` vs `map` em array de 20 elementos)
- "Vamos usar Web Workers porque pode ser lento"

## ❌ Exemplo (violação)

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

## ✅ Refatoração

```javascript
// ✅ Make it work → Make it right → Make it fast
function getUser(id) {
  return db.find(id);
}

// Após medir e confirmar que é o gargalo:
// const getUser = memoize(db.find.bind(db), { ttl: 60_000, max: 500 });
```

## Codetag sugerida

```typescript
// FIXME: Premature Optimization — cache manual sem evidência de necessidade
// TODO: Remover cache; adicionar apenas se profiling mostrar gargalo real
```
