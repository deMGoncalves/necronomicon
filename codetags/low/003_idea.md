# IDEA

**Severidade**: 🟢 Low
**Categoria**: Documentação e Contexto
**Resolver**: Backlog / Avaliar futuramente

---

## Definição

Marca **sugestão de melhoria futura** ou ideia que ainda não foi validada ou priorizada. Diferente de TODO (tarefa confirmada), IDEA é uma proposta a ser considerada.

## Quando Usar

| Situação | Exemplo |
|----------|---------|
| Melhoria não confirmada | "Seria bom se..." |
| Exploração futura | Tecnologia a avaliar |
| Otimização potencial | Pode ou não valer a pena |
| Feature request informal | Ideia do dev |

## Quando NÃO Usar

| Situação | Use em vez |
|----------|------------|
| Tarefa confirmada | TODO |
| Otimização necessária | OPTIMIZE |
| Refatoração identificada | REFACTOR |
| Pergunta sobre abordagem | QUESTION |

## Formato

```javascript
// IDEA: sugestão de melhoria
// IDEA: explorar X para resolver Y
// IDEA: considerar para v2
```

## Exemplos

### Exemplo 1: Feature Potencial

```javascript
// IDEA: adicionar suporte a exportação em CSV além de JSON
// Alguns usuários pediram, mas não é prioridade agora
function exportData(data, format = 'json') {
  if (format === 'json') {
    return JSON.stringify(data);
  }
  throw new Error('Format not supported');
}
```

### Exemplo 2: Tecnologia a Explorar

```javascript
// IDEA: avaliar Rust/WASM para este cálculo pesado
// Benchmark atual: 500ms para 100k items
// WASM poderia reduzir para ~50ms
function heavyComputation(items) {
  return items.reduce((acc, item) => {
    // Cálculo intensivo
  }, 0);
}
```

### Exemplo 3: UX Improvement

```javascript
// IDEA: adicionar skeleton loading em vez de spinner
// Melhor experiência percebida em conexões lentas
function LoadingState() {
  return <Spinner />;
}
```

### Exemplo 4: Arquitetura Futura

```javascript
// IDEA: migrar para event sourcing quando escala exigir
// Atual: ~1000 eventos/dia - CRUD suficiente
// Se passar 100k/dia, reconsiderar
async function saveOrder(order) {
  return db.orders.upsert(order);
}
```

### Exemplo 5: API Enhancement

```javascript
// IDEA: aceitar array de IDs para batch request
// Hoje: clientes fazem N requests para N items
// Futuro: um request com [id1, id2, ...idN]
app.get('/api/items/:id', async (req, res) => {
  const item = await getItem(req.params.id);
  res.json(item);
});
```

### Exemplo 6: Developer Experience

```javascript
// IDEA: criar CLI para scaffolding de novos módulos
// Hoje: copiar pasta template manualmente
// Futuro: `npm run create-module nome-do-modulo`
```

### Exemplo 7: Testing Improvement

```javascript
// IDEA: adicionar visual regression testing para componentes
// Ferramentas a avaliar: Chromatic, Percy, Playwright
function Button({ variant, children }) {
  return <button className={`btn-${variant}`}>{children}</button>;
}
```

## Boas Práticas

### Contextualize o Valor

```javascript
// ❌ IDEA vaga
// IDEA: melhorar isso

// ✅ IDEA com valor claro
// IDEA: cache de queries frequentes - reduziria latência de 200ms para 20ms
```

### Inclua Trade-offs

```javascript
// IDEA: usar WebSocket em vez de polling
// Prós: real-time, menos requests
// Contras: mais complexidade, state management
```

### Vincule a Dados

```javascript
// IDEA: lazy load de imagens - Core Web Vitals mostram LCP de 4.5s
// Estimativa: poderia reduzir para ~2s
```

## Ciclo de Vida

```
IDEA → Avaliação → TODO (se aprovada) → Implementação
                 → Descartada (se não fizer sentido)
```

## Ação Esperada

1. **Registrar** a ideia com contexto
2. **Avaliar** periodicamente em planning
3. **Promover** para TODO se aprovada
4. **Remover** se não fizer mais sentido
5. **Implementar** quando priorizada

## Resolução

| Status | Ação |
|--------|------|
| Ideia ainda válida | Manter |
| Aprovada para implementar | Converter para TODO |
| Não faz mais sentido | Remover |
| Implementada de outra forma | Remover |

## Busca no Código

```bash
# Encontrar IDEAs
grep -rn "IDEA:" src/

# IDEAs por área
grep -rc "IDEA:" src/ | grep -v ":0"

# Gerar relatório de ideias
grep -rn "IDEA:" src/ | awk -F: '{print $1}' | sort | uniq -c
```

## Anti-Patterns

```javascript
// ❌ IDEA sem valor claro
// IDEA: algo aqui
function vague() { }

// ❌ IDEA que deveria ser TODO
// IDEA: corrigir bug X
function hasBug() { } // Se é bug, use FIXME

// ❌ IDEA muito ambiciosa
// IDEA: reescrever tudo em Rust
function works() { } // Seja realista

// ❌ IDEA antiga esquecida
// IDEA: (2018) um dia fazer isso
function ancient() { } // Avalie ou remova

// ❌ Muitas IDEAs no mesmo arquivo
// Indica falta de foco na implementação atual
```

## Gestão de IDEAs

### Revisão Periódica

```bash
# Script para relatório de IDEAs
echo "=== IDEA Report ==="
echo "Total: $(grep -rc "IDEA:" src/ | awk -F: '{sum+=$2} END {print sum}')"
echo ""
echo "Por área:"
grep -rn "IDEA:" src/ | awk -F: '{print $1}' | sort | uniq -c | sort -rn
```

### Integração com Backlog

IDEAs são candidatas naturais para:
- Sprint de inovação / hackathon
- Discussão em retrospectiva
- Tech debt backlog

## Quality Factor Relacionado

- [Flexibility](../../software-quality/revision/002_flexibility.md): IDEAs promovem evolução
- [Adaptability](../../software-quality/operation/006_adaptability.md): pensar no futuro

## Rules Relacionadas

- [clean-code/003 - YAGNI](../../clean-code/003_prohibition-speculative-functionality.md): IDEA ≠ implementar agora
- [clean-code/019 - Boy Scout Rule](../../clean-code/019_regra-escoteiro-refatoracao-continua.md): avaliar IDEAs ao modificar área

---

**Criada em**: 2026-03-19
**Versão**: 1.0
