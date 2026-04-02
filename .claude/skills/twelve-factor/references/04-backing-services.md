# Factor 04 — Backing Services

**Rule deMGoncalves:** [043 - Serviços de Apoio como Recursos](../../../rules/043_servicos-apoio-recursos.md)
**Pergunta:** Serviços externos anexáveis via URL/config (sem mudança de código)?

## O que é

Serviços de apoio (bancos de dados, filas, caches, serviços de email, APIs externas) devem ser tratados como **recursos anexáveis**, acessados via URL ou localizador de recurso armazenado na configuração. A aplicação **não deve distinguir** entre serviços locais e de terceiros.

**Backing service = recurso configurável, não código hardcoded.**

## Critério de Conformidade

- [ ] Todos os serviços externos acessados via **URL ou string de conexão** configurável por variável de ambiente
- [ ] Zero lógica condicional diferenciando serviços locais de remotos (ex: `if (isLocal) useLocalDB()`)
- [ ] Troca de serviço exige **apenas** alteração de config, não de código

## ❌ Violação

```typescript
// Diferenciação hardcoded local vs prod ❌
const db = process.env.NODE_ENV === 'production'
  ? new PostgresClient('prod-url')
  : new SQLiteClient('local.db');

// URL hardcoded ❌
const redis = new Redis({ host: 'localhost', port: 6379 });
```

## ✅ Correto

```typescript
// Serviço como recurso anexável ✅
const dbUrl = process.env.DATABASE_URL;
const redisUrl = process.env.REDIS_URL;

const db = new DatabaseClient(dbUrl);  // PostgreSQL, MySQL, etc
const cache = new RedisClient(redisUrl);  // local ou ElastiCache

// Trocar de SQLite → PostgreSQL = apenas mudar env var
# .env (dev)
DATABASE_URL=sqlite://local.db

# .env (prod)
DATABASE_URL=postgresql://user:pass@db.prod.com/mydb
```

## Codetag quando violado

```typescript
// FIXME: Redis host hardcoded — use process.env.REDIS_URL
const redis = new Redis({ host: '10.0.1.50', port: 6379 });
```
