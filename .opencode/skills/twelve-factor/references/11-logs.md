# Factor 11 — Logs

**Rule deMGoncalves:** [050 - Logs como Fluxo de Eventos](../../../rules/050_logs-fluxo-eventos.md)
**Pergunta:** Logs → stdout (não arquivos locais)?

## O que é

A aplicação deve tratar logs como um **fluxo contínuo de eventos** ordenados por tempo, escritos em `stdout`. A aplicação nunca deve se preocupar com roteamento, armazenamento ou rotação de logs — essa é a responsabilidade do ambiente de execução.

**Logs em arquivos locais = perdidos quando container destruído.**

## Critério de Conformidade

- [ ] Todos os logs escritos em **stdout** (ou stderr para erros), nunca em arquivos locais
- [ ] Zero uso de bibliotecas de logging que escrevem em arquivos ou fazem rotação
- [ ] Logs estruturados (JSON) para facilitar parsing automatizado

## ❌ Violação

```typescript
// Logs em arquivo local ❌
import winston from 'winston';

const logger = winston.createLogger({
  transports: [
    new winston.transports.File({
      filename: '/var/log/app/error.log'  // violação
    })
  ]
});

// Rotação de logs na aplicação ❌
const logger = createLogger({
  rotation: { maxSize: '10m', maxFiles: 5 }  // não é responsabilidade da app
});
```

## ✅ Correto

```typescript
// Logs estruturados para stdout ✅
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  // Default: stdout
});

logger.info({ userId: 123, action: 'login' }, 'User logged in');
// Output (JSON):
// {"level":30,"time":1678901234567,"userId":123,"action":"login","msg":"User logged in"}

// Console simples para dev ✅
if (process.env.NODE_ENV === 'development') {
  console.log('User logged in:', { userId: 123 });
}

// Ambiente captura stdout e roteia ✅
# Docker logs → CloudWatch
# Kubernetes → Fluentd → Elasticsearch
# Heroku → Logplex → Papertrail
```

## Codetag quando violado

```typescript
// FIXME: Logger escrevendo em arquivo — usar stdout apenas
const fileTransport = new winston.transports.File({ filename: 'app.log' });
```
