# Factor 02 — Dependencies

**Rule deMGoncalves:** [041 - Declaração Explícita de Dependências](../../../rules/041_declaracao-explicita-dependencias.md)
**Pergunta:** 100% das dependências explícitas em manifesto (package.json)?

## O que é

Uma aplicação deve declarar **todas** as suas dependências de forma explícita e completa através de um manifesto de dependências (ex: `package.json`, `requirements.txt`). A aplicação **nunca** deve depender da existência implícita de pacotes no sistema.

**Dependências implícitas quebram portabilidade e reprodutibilidade.**

## Critério de Conformidade

- [ ] **100%** das dependências de runtime e build declaradas no manifesto (`package.json`, `bun.lockb`)
- [ ] Zero dependências globais do sistema (ex: `npm install -g`, `apt-get`)
- [ ] Lockfile versionado e atualizado para builds determinísticos

## ❌ Violação

```bash
# Instalação global não rastreada
npm install -g typescript  # violação

# Dependência não declarada em package.json
import express from 'express';  # usado mas não em dependencies

# package.json
{
  "dependencies": {
    "lodash": "^4.17.21"
    // express não declarado ❌
  }
}
```

## ✅ Correto

```bash
# Todas dependências no manifest
npm install --save-exact typescript express lodash

# package.json
{
  "dependencies": {
    "express": "4.18.2",
    "lodash": "4.17.21"
  },
  "devDependencies": {
    "typescript": "5.0.4"
  }
}

# Lockfile versionado
git add package-lock.json  # ou bun.lockb
```

## Codetag quando violado

```typescript
// FIXME: Dependência axios não declarada em package.json
import axios from 'axios';
```
