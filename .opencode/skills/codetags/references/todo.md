# TODO — Tarefa Pendente

**Severidade:** 🟡 Média | Resolver no sprint
**Bloqueia PR:** Não

## O que é

Marca tarefa pendente ou funcionalidade planejada que ainda não foi implementada. É o codetag mais comum e indica trabalho futuro que está no radar da equipe.

## Quando Usar

- Feature parcialmente implementada (falta validação de edge case)
- Placeholder para implementação futura (função com stub)
- Melhoria planejada e confirmada (adicionar cache)
- Integração pendente com serviço externo

## Quando NÃO Usar

- Bug a corrigir → use **FIXME**
- Código a reestruturar → use **REFACTOR**
- Otimização de performance → use **OPTIMIZE**
- Ideia futura não confirmada → use **IDEA**

## Formato

```typescript
// TODO: descrição clara da tarefa
// TODO: [TICKET-123] descrição com rastreamento
// TODO: descrição - prazo se aplicável
```

## Exemplo

```typescript
// TODO: [PROJ-456] adicionar validação de formato de email
function createUser(email: string, password: string) {
  // Validação de email pendente
  return db.users.create({ email, password });
}

// TODO: implementar paginação - limite atual de 100 items
async function listProducts() {
  return db.products.findAll({ limit: 100 });
}

// TODO: implementar retry com exponential backoff
async function fetchWithRetry(url: string) {
  return fetch(url);
}
```

## Resolução

- **Timeline:** Sprint planejada (blocker para feature) ou próxima sprint (melhoria)
- **Ação:** Criar ticket, priorizar no backlog, implementar quando priorizado
- **Convertido em:** Removido após implementação completa

## Relacionado com

- Rules: [023 - YAGNI](../../../.claude/rules/023_proibicao-funcionalidade-especulativa.md) (não criar TODOs especulativos)
- Tags similares: TODO (confirmado) vs IDEA (não confirmado)
