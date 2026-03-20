# OPTIMIZE

**Severidade**: 🟡 Medium
**Categoria**: Ação Requerida
**Resolver**: Backlog técnico / quando performance for problema

---

## Definição

Marca código que pode ter **performance melhorada** mas funciona corretamente. Indica oportunidade de otimização identificada, não um problema urgente.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Algoritmo ineficiente | O(n²) quando poderia ser O(n) |
| Query não otimizada | N+1 queries identificado |
| Cálculo repetido | Sem memoização |
| Carregamento desnecessário | Eager loading excessivo |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Gargalo crítico afetando usuários | PERF (mais urgente) |
| Código incorreto | FIXME |
| Código a reestruturar | REFACTOR |
| Otimização prematura | Não marque |

## Formato

```javascript
// OPTIMIZE: descrição da otimização - complexidade atual vs ideal
// OPTIMIZE: [O(n²) → O(n)] descrição
// OPTIMIZE: descrição - impacto estimado
```

## Exemplos

### Exemplo 1: Complexidade Algorítmica

```javascript
// OPTIMIZE: [O(n²) → O(n)] usar Set para busca em vez de Array.includes
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

// ✅ Otimizado
function findDuplicates(items) {
  const seen = new Set();
  const duplicates = new Set();
  for (const item of items) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }
  return [...duplicates];
}
```

### Exemplo 2: N+1 Query

```javascript
// OPTIMIZE: N+1 queries - usar batch loading
async function getUsersWithPosts(userIds) {
  const users = [];
  for (const id of userIds) {
    const user = await db.users.findById(id);
    user.posts = await db.posts.findByUserId(id); // N queries extras!
    users.push(user);
  }
  return users;
}

// ✅ Otimizado
async function getUsersWithPosts(userIds) {
  const users = await db.users.findByIds(userIds);
  const posts = await db.posts.findByUserIds(userIds);
  const postsByUser = groupBy(posts, 'userId');
  return users.map(u => ({ ...u, posts: postsByUser[u.id] || [] }));
}
```

### Exemplo 3: Cálculo Repetido

```javascript
// OPTIMIZE: recalcula em cada render - adicionar useMemo
function ExpensiveComponent({ data }) {
  const processed = data.map(item => heavyComputation(item));

  return <List items={processed} />;
}

// ✅ Otimizado
function ExpensiveComponent({ data }) {
  const processed = useMemo(
    () => data.map(item => heavyComputation(item)),
    [data]
  );

  return <List items={processed} />;
}
```

### Exemplo 4: Múltiplas Iterações

```javascript
// OPTIMIZE: 3 iterações podem ser 1
function processItems(items) {
  const active = items.filter(i => i.active);
  const names = active.map(i => i.name);
  const total = active.reduce((sum, i) => sum + i.price, 0);
  return { names, total };
}

// ✅ Otimizado
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

### Exemplo 5: Regex em Loop

```javascript
// OPTIMIZE: regex compilada dentro de loop - mover para fora
function validateEmails(emails) {
  return emails.filter(email => {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Recompilada cada iteração
    return regex.test(email);
  });
}

// ✅ Otimizado
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function validateEmails(emails) {
  return emails.filter(email => EMAIL_REGEX.test(email));
}
```

## Princípio: Measure First

```javascript
// ⚠️ IMPORTANTE: Não otimizar prematuramente!
// Sempre medir antes de otimizar:

// 1. Identificar o gargalo real com profiling
// 2. Medir baseline de performance
// 3. Implementar otimização
// 4. Medir novamente para confirmar melhoria
// 5. Documentar os números
```

## Ação Esperada

1. **Identificar** a ineficiência específica
2. **Documentar** complexidade atual vs ideal
3. **Medir** impacto real (se possível)
4. **Priorizar** baseado em impacto
5. **Implementar** quando performance for problema
6. **Medir** novamente após otimização

## Resolução

| Impacto | Quando Resolver |
|---------|-----------------|
| Afetando usuários | Sprint atual |
| Potencial problema futuro | Backlog |
| Micro-otimização | Provavelmente nunca |

## Busca no Código

```bash
# Encontrar OPTIMIZEs
grep -rn "OPTIMIZE:" src/

# OPTIMIZEs com complexidade
grep -rn "OPTIMIZE:.*O(" src/

# Potenciais N+1 (await em loop)
grep -rn -A2 "for.*{" src/ | grep "await"
```

## Anti-Patterns

```javascript
// ❌ OPTIMIZE sem especificar o ganho
// OPTIMIZE:
function slow() { }

// ❌ Otimização prematura
// OPTIMIZE: poderia ser 0.001ms mais rápido
function alreadyFast() { }

// ❌ OPTIMIZE para código incorreto
// OPTIMIZE: melhorar performance
function actuallyBroken() { } // Use FIXME

// ❌ Sem medição
// OPTIMIZE: parece lento
function maybeSlowMaybeNot() { }
```

## Quality Factor Relacionado

- [Efficiency](../../software-quality/operation/003_efficiency.md): OPTIMIZE indica oportunidade de melhoria

## Rules Relacionadas

- [clean-code/002 - KISS](../../clean-code/priorizacao-simplicidade-clareza.md): não complicar por micro-otimização
- [object-calisthenics/001 - Single Indentation](../../object-calisthenics/001_single-indentation-level.md): loops aninhados são candidatos

---

**Criada em**: 2026-03-19
**Versão**: 1.0
