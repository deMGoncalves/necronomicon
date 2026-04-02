# BUG — Defeito Conhecido Documentado e Rastreado

**Severidade:** 🔴 Crítica
**Bloqueia PR:** Não (mas deve ser priorizado)

## O que é

Documenta um defeito conhecido que causa falha ou comportamento inesperado, mas que está sendo rastreado e será corrigido em momento planejado. Diferente de FIXME (correção imediata), BUG indica um problema documentado com ticket/issue associado.

## Quando Usar

- Defeito com ticket aberto (bug reportado e priorizado no backlog)
- Problema conhecido com workaround (usuários contornam temporariamente)
- Bug de terceiros aguardando fix (dependência com issue aberta)
- Problema intermitente em investigação (race condition difícil de reproduzir)

## Quando NÃO Usar

- Bug que precisa de fix imediato → use FIXME
- Código funciona mas é ruim → use REFACTOR
- Problema de segurança → use SECURITY
- Código temporário → use HACK

## Formato

```typescript
// BUG: descrição do problema - ticket/issue
// BUG: [JIRA-123] descrição do comportamento incorreto
// BUG: descrição - workaround: como contornar
```

## Exemplo

```typescript
// BUG: [PROJ-456] toast notification não aparece no Safari iOS
// Workaround: usuários podem ver notificações na página de histórico
function showNotification(message: string): void {
  toast.show(message); // Não funciona em Safari iOS < 15
}

// BUG: race condition quando múltiplos requests chegam simultaneamente
// Ocorre em ~2% dos casos de alto tráfego
// Investigação em andamento - ticket PERF-789
async function processOrder(order: Order): Promise<void> {
  const inventory = await getInventory();
  // Inventory pode mudar entre get e update
  await updateInventory(order);
}
```

## Resolução

- **Timeline:** Sprint atual (crítico) ou próximas 2 sprints (com workaround)
- **Ação:** Documentar → Criar ticket → Adicionar referência → Documentar workaround → Priorizar → Remover após correção
- **Convertido em:** N/A (removido após correção)

## Relacionado com

- Rules: [027](../../../.claude/rules/027_qualidade-tratamento-erros-dominio.md), [032](../../../.claude/rules/032_cobertura-teste-minima-qualidade.md)
- Tags similares: BUG é planejado, FIXME é imediato
