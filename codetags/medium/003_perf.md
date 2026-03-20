# PERF

**Severidade**: 🟡 Medium
**Categoria**: Alerta e Aviso
**Resolver**: Sprint atual (se afetando usuários)

---

## Definição

Marca **ponto de gargalo de performance** identificado que está causando ou pode causar problemas. Mais urgente que OPTIMIZE - indica problema já medido ou observado.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Gargalo medido | Query levando > 1s |
| Problema observado | UI travando |
| Limite de recursos | Memory leak identificado |
| Timeout frequente | API expirando |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Otimização teórica | OPTIMIZE |
| Código incorreto | FIXME |
| Melhoria de estrutura | REFACTOR |
| Suspeita sem medição | Medir primeiro |

## Formato

```javascript
// PERF: descrição do gargalo - métrica medida
// PERF: [p95: 2.5s] descrição - target: 500ms
// PERF: descrição - impacto: X usuários afetados
```

## Exemplos

### Exemplo 1: Query Lenta

```javascript
// PERF: [p95: 3.2s] query sem índice - adicionar índice em user_id
// Target: < 100ms | Afeta: página de pedidos
async function getOrderHistory(userId) {
  return db.query(`
    SELECT * FROM orders
    WHERE user_id = ?
    ORDER BY created_at DESC
  `, [userId]);
}
```

### Exemplo 2: Memory Leak

```javascript
// PERF: memory leak - event listeners não removidos
// Memória cresce 50MB/hora em uso contínuo
function setupListeners(element) {
  window.addEventListener('resize', handleResize);
  window.addEventListener('scroll', handleScroll);
  // Missing: cleanup function to remove listeners
}

// ✅ Corrigido
function setupListeners(element) {
  window.addEventListener('resize', handleResize);
  window.addEventListener('scroll', handleScroll);

  return () => {
    window.removeEventListener('resize', handleResize);
    window.removeEventListener('scroll', handleScroll);
  };
}
```

### Exemplo 3: Bundle Size

```javascript
// PERF: [+250KB] import completo do lodash
// Impacto: +1.5s no LCP mobile
import _ from 'lodash';

const result = _.pick(data, ['id', 'name']);

// ✅ Otimizado
import pick from 'lodash/pick';

const result = pick(data, ['id', 'name']);
```

### Exemplo 4: Re-renders Excessivos

```javascript
// PERF: re-render em cada keystroke - debounce necessário
// CPU: 100% durante digitação rápida
function SearchComponent() {
  const [query, setQuery] = useState('');

  useEffect(() => {
    fetchResults(query); // Chamada a cada caractere
  }, [query]);

  return <input onChange={e => setQuery(e.target.value)} />;
}

// ✅ Otimizado
function SearchComponent() {
  const [query, setQuery] = useState('');
  const debouncedQuery = useDebounce(query, 300);

  useEffect(() => {
    fetchResults(debouncedQuery);
  }, [debouncedQuery]);

  return <input onChange={e => setQuery(e.target.value)} />;
}
```

### Exemplo 5: Blocking I/O

```javascript
// PERF: fs.readFileSync bloqueia event loop
// Latência: +500ms em requests concorrentes
function getConfig() {
  const data = fs.readFileSync('./config.json', 'utf8');
  return JSON.parse(data);
}

// ✅ Otimizado
async function getConfig() {
  const data = await fs.promises.readFile('./config.json', 'utf8');
  return JSON.parse(data);
}
```

### Exemplo 6: Imagem Não Otimizada

```javascript
// PERF: imagens sem lazy loading - LCP 4.5s em mobile
// 15 imagens carregadas no initial load
function Gallery({ images }) {
  return images.map(img => (
    <img src={img.url} alt={img.alt} />
  ));
}

// ✅ Otimizado
function Gallery({ images }) {
  return images.map((img, i) => (
    <img
      src={img.url}
      alt={img.alt}
      loading={i < 4 ? 'eager' : 'lazy'}
    />
  ));
}
```

## Métricas Comuns

| Tipo | Métricas | Ferramentas |
|------|----------|-------------|
| Backend | p50, p95, p99, throughput | APM, Datadog |
| Frontend | LCP, FID, CLS, TTI | Lighthouse, WebVitals |
| Database | Query time, connections | EXPLAIN, slow query log |
| Memory | Heap size, GC frequency | Chrome DevTools, clinic.js |

## Ação Esperada

1. **Medir** e documentar a métrica atual
2. **Definir** target de performance
3. **Identificar** causa raiz
4. **Priorizar** baseado em impacto
5. **Implementar** correção
6. **Medir** novamente para confirmar
7. **Monitorar** para evitar regressão

## Resolução

| Impacto | Quando Resolver |
|---------|-----------------|
| Usuários reclamando | Imediatamente |
| Degradação mensurável | Sprint atual |
| Potencial problema | Próxima sprint |
| Micro-otimização | Backlog ou ignorar |

## Busca no Código

```bash
# Encontrar PERFs
grep -rn "PERF:" src/

# PERFs com métricas
grep -rn "PERF:.*\[" src/

# Potenciais problemas (sync I/O)
grep -rn "readFileSync\|writeFileSync" src/
```

## Diferença entre PERF e OPTIMIZE

| Aspecto | PERF | OPTIMIZE |
|---------|------|----------|
| Urgência | Problema real | Oportunidade |
| Medição | Já medido | Estimativa |
| Impacto | Visível | Potencial |
| Prioridade | Sprint atual | Backlog |

## Anti-Patterns

```javascript
// ❌ PERF sem métricas
// PERF: lento
function noMetrics() { }

// ❌ PERF para suspeita
// PERF: parece lento
function notMeasured() { } // Medir primeiro

// ❌ PERF para micro-otimização
// PERF: poderia ser 1ms mais rápido
function alreadyFast() { }
```

## Quality Factor Relacionado

- [Efficiency](../../software-quality/operation/003_efficiency.md): PERF indica problema de eficiência real

## Rules Relacionadas

- [clean-code/002 - KISS](../../clean-code/priorizacao-simplicidade-clareza.md): código simples geralmente é mais performático
- [object-calisthenics/001 - Single Indentation](../../object-calisthenics/001_single-indentation-level.md): menos aninhamento = menos complexidade

---

**Criada em**: 2026-03-19
**Versão**: 1.0
