# Factor 08 — Concurrency

**Rule deMGoncalves:** [047 - Concorrência via Processos](../../../rules/047_concorrencia-via-processos.md)
**Pergunta:** Aplicação escala via múltiplos processos (não threads ou processo único)?

## O que é

A aplicação deve escalar horizontalmente através da execução de **múltiplos processos independentes**, não através de threads internas ou um único processo monolítico. Diferentes tipos de trabalho (web, worker, scheduler) devem ser separados em tipos de processos distintos.

**Escalabilidade elástica = adicionar processos conforme demanda.**

## Critério de Conformidade

- [ ] Aplicação suporta execução de **múltiplas instâncias** do mesmo processo sem conflito
- [ ] Diferentes cargas de trabalho (HTTP, background jobs, scheduled tasks) separadas em processos distintos
- [ ] Processo não *daemonize* nem escreve PID files (gerenciamento é do ambiente)

## ❌ Violação

```typescript
// Processo único que faz tudo ❌
const app = express();
app.listen(3000);

// Background jobs no mesmo processo
setInterval(() => {
  processQueue();  // viola concurrency
}, 5000);

// Não escala horizontalmente
// Se duplicar processo, processQueue() roda 2x
```

## ✅ Correto

```typescript
// Processo web separado (web.ts) ✅
const app = express();
app.listen(process.env.PORT);

// Processo worker separado (worker.ts) ✅
const queue = new Queue(process.env.REDIS_URL);
queue.process('email', sendEmail);

// Procfile define tipos de processo
# Procfile
web: bun run src/web.ts
worker: bun run src/worker.ts
scheduler: bun run src/scheduler.ts

# Escala independente
heroku ps:scale web=4 worker=2 scheduler=1
```

## Codetag quando violado

```typescript
// FIXME: Background job no processo web — extrair para worker process
setInterval(cleanupDatabase, 3600000);
```
