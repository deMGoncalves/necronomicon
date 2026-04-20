# Factor 01 — Codebase

**Rule deMGoncalves:** [040 - Base de Código Única](../../../rules/040_base-codigo-unica.md)
**Pergunta:** Uma aplicação = um repositório rastreado em controle de versão?

## O que é

Uma aplicação deve ter exatamente uma base de código rastreada no controle de versão, com múltiplos deploys originando dessa mesma base. A relação entre base de código e aplicação é sempre **1:1**.

**Múltiplas bases de código = sistema distribuído, não uma aplicação.**
**Código compartilhado = extrair para biblioteca com versionamento independente.**

## Critério de Conformidade

- [ ] A aplicação possui **um único repositório** Git com branches para ambientes (dev, staging, prod)
- [ ] Código compartilhado entre aplicações foi extraído para **bibliotecas independentes** com versionamento próprio
- [ ] Zero ocorrências de *copy-paste deployment* entre repositórios

## ❌ Violação

```bash
# Estrutura de múltiplas bases de código para mesma app
repo-app-frontend/
repo-app-backend/
repo-app-workers/

# Código duplicado em múltiplos repos
repo-app-a/src/utils/validation.js  # duplicado
repo-app-b/src/utils/validation.js  # violação
```

## ✅ Correto

```bash
# Único repositório com múltiplos ambientes
repo-app/
├── .git/
├── src/
│   ├── frontend/
│   ├── backend/
│   └── workers/
└── branches: main, staging, dev

# Código compartilhado extraído para biblioteca
@company/validation-lib  # npm package independente
  ├── version: 1.2.3
  └── usado por: app-a, app-b, app-c
```

## Codetag quando violado

```typescript
// FIXME: Código duplicado em múltiplos repos — extrair para @company/shared-utils
function validateEmail(email: string): boolean { /* ... */ }
```
