# PERF — Gargalo de Performance

**Severidade:** 🟡 Média | Resolver no sprint atual se afetando usuários
**Bloqueia PR:** Não (mas deve ser priorizado)

## O que é

Marca ponto de gargalo de performance identificado que está causando ou pode causar problemas reais. Mais urgente que OPTIMIZE - indica problema já medido ou observado em produção.

## Quando Usar

- Gargalo medido com métricas (query levando > 1s)
- Problema observado por usuários (UI travando)
- Limite de recursos atingido (memory leak identificado)
- Timeout frequente (API expirando em > 10% das requests)

## Quando NÃO Usar

- Otimização teórica sem medição → use **OPTIMIZE**
- Código incorreto → use **FIXME**
- Melhoria de estrutura → use **REFACTOR**
- Suspeita sem medição → medir primeiro

## Formato

```typescript
// PERF: descrição do gargalo - métrica medida
// PERF: [p95: 2.5s] descrição - target: 500ms
// PERF: descrição - impacto: X usuários afetados
```

## Exemplo

```typescript
// PERF: [p95: 3.2s] query sem índice - adicionar índice em user_id
// Target: < 100ms | Afeta: página de pedidos
async function getOrderHistory(userId: string) {
  return db.query(`
    SELECT * FROM orders
    WHERE user_id = ?
    ORDER BY created_at DESC
  `, [userId]);
}

// PERF: memory leak - event listeners não removidos
// Memória cresce 50MB/hora em uso contínuo
function setupListeners(element: HTMLElement) {
  window.addEventListener('resize', handleResize);
  window.addEventListener('scroll', handleScroll);
  // Missing: cleanup function to remove listeners
}

// PERF: [+250KB] import completo do lodash
// Impacto: +1.5s no LCP mobile
import _ from 'lodash';
const result = _.pick(data, ['id', 'name']);

// PERF: re-render em cada keystroke - debounce necessário
// CPU: 100% durante digitação rápida
function SearchComponent() {
  const [query, setQuery] = useState('');
  useEffect(() => {
    fetchResults(query); // Chamada a cada caractere
  }, [query]);
  return <input onChange={e => setQuery(e.target.value)} />;
}
```

## Resolução

- **Timeline:** Imediatamente (usuários reclamando) ou sprint atual (degradação mensurável)
- **Ação:** Medir métrica atual, definir target, identificar causa raiz, implementar correção, medir novamente, monitorar
- **Convertido em:** Removido após correção confirmada por métricas

## Relacionado com

- Rules: [022 - KISS](../../../.claude/rules/022_priorizacao-simplicidade-clareza.md) (código simples é mais performático)
- Tags similares: PERF (problema real) vs OPTIMIZE (oportunidade teórica)
