# Efficiency (Eficiência)

**Dimensão**: Operação
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**Ele tem boa performance?**

## Definição

A quantidade de recursos computacionais e código necessários para o software realizar suas funções. Eficiência abrange tempo de execução (CPU), uso de memória, consumo de banda e otimização de I/O.

## Critérios de Verificação

- [ ] Complexidade algorítmica adequada (Big O)
- [ ] Uso eficiente de memória
- [ ] Operações desnecessárias eliminadas
- [ ] Caching quando apropriado
- [ ] Queries de banco otimizadas
- [ ] Lazy loading para recursos pesados

## Indicadores de Problema

### Exemplo 1: Complexidade O(n²) Desnecessária

```javascript
// ❌ Ineficiente - O(n²) desnecessário
function findDuplicates(items) {
  const duplicates = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (items[i] === items[j]) {
        duplicates.push(items[i]);
      }
    }
  }
  return duplicates;
}

// ✅ Eficiente - O(n) com Set
function findDuplicates(items) {
  const seen = new Set();
  const duplicates = new Set();

  for (const item of items) {
    if (seen.has(item)) {
      duplicates.add(item);
    }
    seen.add(item);
  }

  return [...duplicates];
}
```

### Exemplo 2: Múltiplas Iterações Desnecessárias

```javascript
// ❌ Ineficiente - 3 iterações
function processItems(items) {
  const active = items.filter(item => item.active);
  const names = active.map(item => item.name);
  const total = active.reduce((sum, item) => sum + item.price, 0);
  return { names, total };
}

// ✅ Eficiente - 1 iteração
function processItems(items) {
  const result = { names: [], total: 0 };

  for (const item of items) {
    if (item.active) {
      result.names.push(item.name);
      result.total += item.price;
    }
  }

  return result;
}
```

### Exemplo 3: N+1 Query Problem

```javascript
// ❌ Ineficiente - N+1 queries
async function getUsersWithPosts(userIds) {
  const users = [];
  for (const id of userIds) {
    const user = await db.users.findById(id);
    user.posts = await db.posts.findByUserId(id); // N queries extras
    users.push(user);
  }
  return users;
}

// ✅ Eficiente - 2 queries
async function getUsersWithPosts(userIds) {
  const users = await db.users.findByIds(userIds);
  const posts = await db.posts.findByUserIds(userIds);

  const postsByUser = groupBy(posts, 'userId');

  return users.map(user => ({
    ...user,
    posts: postsByUser[user.id] || []
  }));
}
```

### Exemplo 4: Recálculo Desnecessário

```javascript
// ❌ Ineficiente - recalcula em cada chamada
function getExpensiveValue() {
  return heavyComputation(); // Sempre recalcula
}

// ✅ Eficiente - memoização
const getExpensiveValue = memoize(() => {
  return heavyComputation();
});

// Ou com lazy initialization
let cachedValue = null;
function getExpensiveValue() {
  if (cachedValue === null) {
    cachedValue = heavyComputation();
  }
  return cachedValue;
}
```

## Sinais de Alerta em Code Review

1. **Loops aninhados** em coleções grandes
2. **Múltiplos filter/map/reduce** encadeados
3. **Queries dentro de loops** (N+1 problem)
4. **Objetos grandes** criados desnecessariamente
5. **Regex compilada** dentro de loops
6. **Cálculos repetidos** sem cache

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Lista com milhares de items | UI travada |
| API com alto volume | Timeout/alta latência |
| Mobile | Bateria drenada |
| Servidor | Custos elevados |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Performance crítica (< 100ms required) | 🔴 Blocker |
| Lista com 10k+ items | 🟠 Important |
| Lista com < 100 items | 🟡 Suggestion |
| Código executado raramente | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// OPTIMIZE: Este loop O(n²) pode ser O(n) com Set
// PERFORMANCE: N+1 queries - considerar batch loading

// TODO: Adicionar memoização para esta função pesada
```

## Exemplo de Comentário em Review

```
Estás iterando la lista 3 veces (filter, map, reduce). En listas chicas no importa, pero podrías hacerlo en una pasada:

const result = items.reduce((acc, item) => {
  if (item.active) {
    acc.total += item.price;
    acc.items.push(item.name);
  }
  return acc;
}, { total: 0, items: [] });

🟡 Sugerencia de performance
```

## Rules Relacionadas

- [clean-code/002 - Simplicity (KISS)](../../clean-code/002_prioritization-simplicity-clarity.md)
- [object-calisthenics/001 - Single Indentation](../../object-calisthenics/001_single-indentation-level.md)

## Patterns Relacionados

- [gof/structural/006 - Flyweight](../../gof/structural/006_flyweight.md): para otimização de memória
- [gof/structural/007 - Proxy](../../gof/structural/007_proxy.md): para lazy loading
- [poeaa/object-relational/003 - Lazy Load](../../poeaa/object-relational/003_lazy-load.md): para carregamento sob demanda

---

**Criada em**: 2026-03-18
**Versão**: 1.0
