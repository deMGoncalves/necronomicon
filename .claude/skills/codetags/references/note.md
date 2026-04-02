# NOTE — Informação Importante

**Severidade:** 🟢 Baixa | Informativo
**Bloqueia PR:** Não

## O que é

Marca informação importante sobre decisão, contexto ou comportamento não óbvio. Diferente de comentários comuns, NOTE destaca algo que o leitor precisa saber para entender ou modificar o código com segurança.

## Quando Usar

- Decisão de design (por que foi escolhida essa abordagem)
- Comportamento não óbvio (efeito colateral intencional)
- Contexto histórico (razão de código "estranho")
- Dependência importante (ordem que precisa ser mantida)

## Quando NÃO Usar

- Tarefa pendente → use **TODO**
- Código perigoso → use **XXX**
- Explicação do óbvio → não comente
- Documentação de API → use JSDoc/TSDoc

## Formato

```typescript
// NOTE: informação importante
// NOTE: razão da decisão técnica
// NOTE: contexto que afeta manutenção futura
```

## Exemplo

```typescript
// NOTE: usando Map em vez de Object para preservar ordem de inserção
// e permitir chaves não-string (ex: objetos como chave)
const cache = new Map<string, CacheEntry>();

// NOTE: retorno null é intencional - indica "não encontrado" vs erro
// Caller deve verificar: if (result === null) { handleNotFound() }
function findUser(id: string): User | null {
  const user = users.get(id);
  return user || null;
}

// NOTE: timeout de 30s é requisito do parceiro de pagamento
// Documentação: https://docs.partner.com/timeouts
// Não reduzir sem validar com eles primeiro
const PAYMENT_TIMEOUT = 30000;

// NOTE: ordem dos middlewares é crítica
// 1. Auth deve vir antes de rate-limit (para identificar usuário)
// 2. Rate-limit deve vir antes de validation (para bloquear abuso)
app.use(authMiddleware);
app.use(rateLimitMiddleware);
app.use(validationMiddleware);

// NOTE: usando eager loading aqui apesar do custo
// Trade-off: +100ms no load vs N+1 queries na renderização
// Testado: eager é 3x mais rápido no caso de uso típico
const orders = await db.orders.findAll({
  include: [{ model: OrderItem }, { model: Customer }]
});

// NOTE: formato de data mantido para compatibilidade com API mobile v1
// Novos endpoints usam ISO 8601, mas este precisa manter DD/MM/YYYY
// Migração planejada para Q3 quando v1 for descontinuada
function formatDateLegacy(date: Date): string {
  return format(date, 'dd/MM/yyyy');
}
```

## Resolução

- **Timeline:** N/A (informativo, não requer ação)
- **Ação:** Ler antes de modificar código, atualizar se informação ficar desatualizada, remover se não for mais relevante
- **Convertido em:** Atualizado ou removido quando contexto mudar

## Relacionado com

- Rules: [026 - Comments Quality](../../../.claude/rules/026_qualidade-comentarios-porque.md) (NOTE explica o "porquê")
- Tags similares: NOTE (decisão crítica) vs INFO (detalhe técnico)
