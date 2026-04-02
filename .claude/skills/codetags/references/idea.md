# IDEA — Sugestão de Melhoria Futura

**Severidade:** 🟢 Baixa | Avaliar futuramente
**Bloqueia PR:** Não

## O que é

Marca sugestão de melhoria futura ou ideia que ainda não foi validada ou priorizada. Diferente de TODO (tarefa confirmada), IDEA é uma proposta a ser considerada em planning ou retrospectivas.

## Quando Usar

- Melhoria não confirmada ("seria bom se...")
- Exploração futura (tecnologia a avaliar)
- Otimização potencial (pode ou não valer a pena)
- Feature request informal (ideia do desenvolvedor)

## Quando NÃO Usar

- Tarefa confirmada → use **TODO**
- Otimização necessária → use **OPTIMIZE**
- Refatoração identificada → use **REFACTOR**
- Pergunta sobre abordagem → use **QUESTION**

## Formato

```typescript
// IDEA: sugestão de melhoria
// IDEA: explorar X para resolver Y
// IDEA: considerar para v2 ou próxima iteração
```

## Exemplo

```typescript
// IDEA: adicionar suporte a exportação em CSV além de JSON
// Alguns usuários pediram, mas não é prioridade agora
function exportData(data: any[], format = 'json'): string {
  if (format === 'json') {
    return JSON.stringify(data);
  }
  throw new Error('Format not supported');
}

// IDEA: avaliar Rust/WASM para este cálculo pesado
// Benchmark atual: 500ms para 100k items
// WASM poderia reduzir para ~50ms
function heavyComputation(items: Item[]): number {
  return items.reduce((acc, item) => {
    // Cálculo intensivo
  }, 0);
}

// IDEA: adicionar skeleton loading em vez de spinner
// Melhor experiência percebida em conexões lentas
function LoadingState() {
  return <Spinner />;
}

// IDEA: migrar para event sourcing quando escala exigir
// Atual: ~1000 eventos/dia - CRUD suficiente
// Se passar 100k/dia, reconsiderar
async function saveOrder(order: Order) {
  return db.orders.upsert(order);
}

// IDEA: aceitar array de IDs para batch request
// Hoje: clientes fazem N requests para N items
// Futuro: um request com [id1, id2, ...idN]
app.get('/api/items/:id', async (req, res) => {
  const item = await getItem(req.params.id);
  res.json(item);
});

// IDEA: criar CLI para scaffolding de novos módulos
// Hoje: copiar pasta template manualmente
// Futuro: `npm run create-module nome-do-modulo`

// IDEA: adicionar visual regression testing para componentes
// Ferramentas a avaliar: Chromatic, Percy, Playwright
function Button({ variant, children }) {
  return <button className={`btn-${variant}`}>{children}</button>;
}
```

## Resolução

- **Timeline:** Backlog / avaliar em planning ou retrospectiva
- **Ação:** Registrar com contexto, avaliar periodicamente, promover para TODO se aprovada, remover se não fizer sentido
- **Convertido em:** TODO (se aprovada) ou removido (se descartada)

## Relacionado com

- Rules: [023 - YAGNI](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md) (IDEA ≠ implementar agora)
- Tags similares: IDEA (não confirmada) vs TODO (confirmada e priorizada)
