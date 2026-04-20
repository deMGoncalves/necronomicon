# Factor 06 — Processes

**Rule deMGoncalves:** [045 - Processos Stateless](../../../rules/045_processos-stateless.md)
**Pergunta:** Processos stateless + share-nothing (estado em backing service)?

## O que é

Os processos da aplicação devem ser **stateless** (sem estado) e **share-nothing**. Qualquer dado que precise persistir deve ser armazenado em um serviço de apoio com estado (banco de dados, cache distribuído, object storage).

**Estado em memória/filesystem local impede escalabilidade horizontal.**

## Critério de Conformidade

- [ ] Zero armazenamento de estado de sessão em memória local (usar Redis, banco de dados)
- [ ] Zero dependência de arquivos no filesystem local entre requisições
- [ ] Processo pode reiniciar a qualquer momento sem perda de dados do usuário

## ❌ Violação

```typescript
// Session em memória local ❌
const sessions = new Map();  // perdido ao reiniciar
app.post('/login', (req, res) => {
  sessions.set(req.body.userId, { token: '...' });
});

// Filesystem local como storage ❌
app.post('/upload', (req, res) => {
  fs.writeFileSync('/tmp/uploads/' + req.file.name, req.file.data);
  // ❌ arquivo não estará disponível em outro processo
});
```

## ✅ Correto

```typescript
// Session em backing service ✅
const redis = new RedisClient(process.env.REDIS_URL);
app.post('/login', async (req, res) => {
  await redis.set(`session:${userId}`, JSON.stringify({ token: '...' }));
});

// Upload para object storage ✅
const s3 = new S3Client({ endpoint: process.env.S3_ENDPOINT });
app.post('/upload', async (req, res) => {
  await s3.putObject({
    Bucket: 'uploads',
    Key: req.file.name,
    Body: req.file.data
  });
});
```

## Codetag quando violado

```typescript
// FIXME: Session storage em memória local — move to Redis
const userSessions = new Map<string, Session>();
```
