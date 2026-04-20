# Factor 09 — Disposability

**Rule deMGoncalves:** [048 - Descartabilidade de Processos](../../../rules/048_descartabilidade-processos.md)
**Pergunta:** Startup rápido (<10s) + graceful shutdown (SIGTERM tratado)?

## O que é

Os processos da aplicação devem ser **descartáveis** — podem ser iniciados ou encerrados a qualquer momento. Isso requer inicialização rápida, desligamento gracioso e robustez contra terminação súbita (SIGTERM/SIGKILL).

**Descartabilidade = deploys rápidos + escalabilidade elástica + fast recovery.**

## Critério de Conformidade

- [ ] Tempo de **startup** inferior a **10 segundos** para estar pronto
- [ ] Processo trata **SIGTERM** e finaliza requisições em andamento graciosamente
- [ ] Background jobs são **idempotentes** e usam retry (podem ser interrompidos)

## ❌ Violação

```typescript
// Startup lento (>30s) ❌
app.listen(3000, async () => {
  await loadHugeDatasetIntoMemory();  // 45s
  await warmupAllCaches();  // 20s
  console.log('Ready');
});

// Sem tratamento de SIGTERM ❌
// Processo é killed abruptamente
// Requisições em andamento são perdidas
```

## ✅ Correto

```typescript
// Startup rápido (<5s) ✅
const server = app.listen(process.env.PORT, () => {
  console.log('Server ready');
});

// Graceful shutdown ✅
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, closing server gracefully');

  server.close(async () => {
    // Finalizar requisições em andamento
    await cleanupConnections();
    process.exit(0);
  });

  // Timeout se não finalizar em 30s
  setTimeout(() => {
    console.error('Forced shutdown');
    process.exit(1);
  }, 30000);
});

// Jobs idempotentes ✅
queue.process('email', async (job) => {
  const { userId, templateId } = job.data;

  // Verificar se já foi processado (idempotência)
  const sent = await db.emailLog.findOne({ userId, templateId });
  if (sent) return;

  await sendEmail(userId, templateId);
});
```

## Codetag quando violado

```typescript
// FIXME: Sem tratamento de SIGTERM — adicionar graceful shutdown
process.on('SIGTERM', () => process.exit(0));  // violação
```
