# Factor 03 — Config

**Rule deMGoncalves:** [042 - Configurações via Ambiente](../../../rules/042_configuracoes-via-ambiente.md)
**Pergunta:** Configurações em env vars (não hardcoded)?

## O que é

Todas as configurações que variam entre ambientes (*deploy*) devem ser armazenadas em **variáveis de ambiente**, não em arquivos de configuração versionados ou hardcoded no código. Isso inclui credenciais, URLs de serviços e feature flags.

**Config hardcoded = risco de vazamento + deploys inflexíveis.**

## Critério de Conformidade

- [ ] Credenciais (API keys, senhas, tokens) acessadas **exclusivamente** via `process.env`
- [ ] Zero arquivos `.env` com valores reais versionados (apenas `.env.example`)
- [ ] Código funciona com zero arquivos de configuração específicos de ambiente no repositório

## ❌ Violação

```typescript
// Credencial hardcoded ❌
const stripeKey = "sk_live_<YOUR_KEY_HERE>";

// URL hardcoded ❌
const apiUrl = "https://api.production.com";

// .env versionado com secrets ❌
git add .env  # contém API_KEY=sk_live_...
```

## ✅ Correto

```typescript
// Config via env vars ✅
const stripeKey = process.env.STRIPE_SECRET_KEY;
const apiUrl = process.env.API_BASE_URL;

if (!stripeKey) {
  throw new Error('STRIPE_SECRET_KEY not configured');
}

// .env.example versionado (apenas template)
# .env.example
STRIPE_SECRET_KEY=sk_test_your_key_here
API_BASE_URL=https://api.staging.com

// .gitignore
.env
.env.local
```

## Codetag quando violado

```typescript
// FIXME: API key hardcoded — move to process.env.SENDGRID_API_KEY
const sendgridKey = "SG.abc123...";
```
