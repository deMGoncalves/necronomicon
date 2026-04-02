# OPTIMIZE — Oportunidade de Otimização

**Severidade:** 🟡 Média | Resolver quando performance for problema
**Bloqueia PR:** Não

## O que é

Marca código que pode ter performance melhorada mas funciona corretamente. Indica oportunidade de otimização identificada, não um problema urgente afetando usuários.

## Quando Usar

- Algoritmo ineficiente (O(n²) quando poderia ser O(n))
- Query não otimizada (N+1 queries identificado)
- Cálculo repetido sem memoização
- Carregamento desnecessário (eager loading excessivo)

## Quando NÃO Usar

- Gargalo crítico afetando usuários → use **PERF** (mais urgente)
- Código incorreto → use **FIXME**
- Código a reestruturar → use **REFACTOR**
- Otimização prematura sem medição → não marque

## Formato

```typescript
// OPTIMIZE: descrição - complexidade atual vs ideal
// OPTIMIZE: [O(n²) → O(n)] descrição da otimização
// OPTIMIZE: descrição - impacto estimado em milissegundos
```

## Exemplo

```typescript
// OPTIMIZE: [O(n²) → O(n)] usar Set para busca em vez de Array.includes
function findDuplicates(items: string[]): string[] {
  const duplicates: string[] = [];
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      if (items[i] === items[j]) {
        duplicates.push(items[i]);
      }
    }
  }
  return duplicates;
}

// OPTIMIZE: N+1 queries - usar batch loading
async function getUsersWithPosts(userIds: string[]) {
  const users = [];
  for (const id of userIds) {
    const user = await db.users.findById(id);
    user.posts = await db.posts.findByUserId(id); // N queries extras
    users.push(user);
  }
  return users;
}

// OPTIMIZE: recalcula em cada render - adicionar useMemo
function ExpensiveComponent({ data }: { data: Item[] }) {
  const processed = data.map(item => heavyComputation(item));
  return <List items={processed} />;
}
```

## Resolução

- **Timeline:** Sprint atual (se afetando usuários) ou backlog técnico
- **Ação:** Medir baseline, implementar otimização, medir novamente
- **Convertido em:** Removido após otimização ou descartado se micro-otimização

## Relacionado com

- Rules: [022 - KISS](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md) (não complicar por micro-otimização)
- Tags similares: OPTIMIZE (oportunidade) vs PERF (problema real medido)
