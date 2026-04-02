# Factor 10 — Dev/Prod Parity

**Rule deMGoncalves:** [049 - Paridade Dev/Prod](../../../rules/049_paridade-dev-prod.md)
**Pergunta:** Dev ≈ Staging ≈ Prod (stack tecnológica + tempo de deploy + pessoas)?

## O que é

Os ambientes de desenvolvimento, staging e produção devem ser tão **similares quanto possível**. Isso inclui minimizar lacunas de tempo (deploy frequente), lacunas de pessoal (quem desenvolve também faz deploy) e lacunas de ferramentas (mesmas tecnologias em todos os ambientes).

**Divergência = bugs que só aparecem em produção.**

## Critério de Conformidade

- [ ] Mesmos **serviços de apoio** (banco, cache, fila) em dev e prod (ex: PostgreSQL em ambos, não SQLite dev + PostgreSQL prod)
- [ ] Tempo entre escrever código e deploy em prod < **1 dia** (idealmente horas)
- [ ] Containers/configs de ambiente **idênticos** (ex: mesmo Dockerfile)

## ❌ Violação

```typescript
// Backing services diferentes ❌
const db = process.env.NODE_ENV === 'production'
  ? new PostgresClient(process.env.DATABASE_URL)
  : new SQLiteClient('dev.db');  // violação

// Deploy manual/infrequente ❌
# Dev → Prod leva 2 semanas
# Desenvolvedor não tem permissão de deploy
```

## ✅ Correto

```typescript
// Mesmo backing service ✅
const db = new PostgresClient(process.env.DATABASE_URL);

# .env (dev)
DATABASE_URL=postgresql://localhost/myapp_dev

# .env (prod)
DATABASE_URL=postgresql://db.prod.com/myapp

// Docker Compose para dev com mesmos services ✅
# docker-compose.yml
services:
  db:
    image: postgres:15  # mesma versão prod
  redis:
    image: redis:7  # mesma versão prod
  app:
    build: .  # mesmo Dockerfile

// Deploy contínuo ✅
# CI/CD pipeline
# Git push → Build → Test → Deploy (< 30min)
```

## Codetag quando violado

```typescript
// FIXME: SQLite em dev mas PostgreSQL em prod — usar PostgreSQL em ambos
const db = isProduction ? new PostgresClient() : new SQLiteClient();
```
