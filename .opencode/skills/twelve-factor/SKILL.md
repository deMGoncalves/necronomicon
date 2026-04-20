---
name: twelve-factor
description: "12 fatores para aplicações cloud-native (Heroku/SaaS). Use quando @developer verificar conformidade com rules 040-051, ou @architect definir requisitos de infraestrutura e deployment."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Twelve-Factor App Methodology

## O que é

The Twelve-Factor App é uma metodologia para construir aplicações SaaS (Software-as-a-Service) que:

- Usam **declaração e automação** para setup, minimizando tempo e custo de onboarding
- Têm **portabilidade máxima** entre ambientes de execução
- São adequadas para **deploy em plataformas cloud** modernas
- Minimizam **divergência entre dev e prod**, permitindo **continuous deployment**
- Podem **escalar horizontalmente** sem mudanças significativas

Criada por desenvolvedores da Heroku, a metodologia sintetiza práticas de centenas de aplicações SaaS em 12 princípios fundamentais.

## Quando Usar

| Cenário | Fator(es) relevante(s) |
|---------|------------------------|
| Configurar novo projeto | 01-Codebase, 02-Dependencies, 03-Config |
| Preparar deploy em produção | 04-Backing Services, 05-Build/Release/Run |
| Escalar aplicação horizontalmente | 06-Processes, 08-Concurrency |
| Garantir resiliência e fast recovery | 09-Disposability |
| Debugar "funciona no meu ambiente" | 10-Dev/Prod Parity |
| Implementar observabilidade | 11-Logs |
| Executar migrations/tasks admin | 12-Admin Processes |
| Port binding e service exposure | 07-Port Binding |

## Os 12 Fatores

| # | Fator | Rule deMGoncalves | Pergunta-chave | Arquivo de Referência |
|---|-------|-------------------|----------------|----------------------|
| 01 | **Codebase** | [040](../../rules/040_base-codigo-unica.md) | 1 app = 1 repositório? | [01-codebase.md](references/01-codebase.md) |
| 02 | **Dependencies** | [041](../../rules/041_declaracao-explicita-dependencias.md) | Todas dependências explícitas em manifest? | [02-dependencies.md](references/02-dependencies.md) |
| 03 | **Config** | [042](../../rules/042_configuracoes-via-ambiente.md) | Config em env vars (não hardcoded)? | [03-config.md](references/03-config.md) |
| 04 | **Backing Services** | [043](../../rules/043_servicos-apoio-recursos.md) | Serviços anexáveis via URL/config? | [04-backing-services.md](references/04-backing-services.md) |
| 05 | **Build, Release, Run** | [044](../../rules/044_separacao-build-release-run.md) | 3 stages separados e imutáveis? | [05-build-release-run.md](references/05-build-release-run.md) |
| 06 | **Processes** | [045](../../rules/045_processos-stateless.md) | Processos stateless + share-nothing? | [06-processes.md](references/06-processes.md) |
| 07 | **Port Binding** | [046](../../rules/046_port-binding.md) | App auto-contida com HTTP server embutido? | [07-port-binding.md](references/07-port-binding.md) |
| 08 | **Concurrency** | [047](../../rules/047_concorrencia-via-processos.md) | Escala via múltiplos processos? | [08-concurrency.md](references/08-concurrency.md) |
| 09 | **Disposability** | [048](../../rules/048_descartabilidade-processos.md) | Startup rápido + graceful shutdown? | [09-disposability.md](references/09-disposability.md) |
| 10 | **Dev/Prod Parity** | [049](../../rules/049_paridade-dev-prod.md) | Dev ≈ Staging ≈ Prod (stack + time + people)? | [10-dev-prod-parity.md](references/10-dev-prod-parity.md) |
| 11 | **Logs** | [050](../../rules/050_logs-fluxo-eventos.md) | Logs → stdout (não arquivos)? | [11-logs.md](references/11-logs.md) |
| 12 | **Admin Processes** | [051](../../rules/051_processos-administrativos.md) | Tasks admin = one-off processes? | [12-admin-processes.md](references/12-admin-processes.md) |

## Seleção Rápida por Contexto

### "Preciso configurar um novo projeto"
→ **Comece por**: 01-Codebase, 02-Dependencies, 03-Config

### "Aplicação não escala horizontalmente"
→ **Verifique**: 06-Processes, 08-Concurrency, 09-Disposability

### "Deploy é manual e arriscado"
→ **Verifique**: 05-Build/Release/Run, 10-Dev/Prod Parity

### "Bug funciona em dev, falha em prod"
→ **Verifique**: 03-Config, 04-Backing Services, 10-Dev/Prod Parity

### "Logs perdidos quando container reinicia"
→ **Verifique**: 11-Logs

### "Migration script quebrou prod mas funciona em dev"
→ **Verifique**: 12-Admin Processes, 10-Dev/Prod Parity

## Proibições

Esta skill detecta e previne:

- **❌ Configurações hardcoded** (viola Factor 03)
- **❌ Dependências implícitas** (viola Factor 02)
- **❌ Estado em memória/filesystem local** (viola Factor 06)
- **❌ Logs em arquivos locais** (viola Factor 11)
- **❌ Scripts admin executados via SSH direto** (viola Factor 12)
- **❌ Servidor web externo obrigatório** (viola Factor 07)
- **❌ Divergência dev/prod em backing services** (viola Factor 10)
- **❌ Processos não descartáveis** (viola Factor 09)

## Fundamentação

**Rules deMGoncalves 040–051** implementam os 12 fatores:

- **Infraestrutura (040-051)**: Toda categoria "INFRAESTRUTURA" mapeia 1:1 para um fator
- **Severidade crítica (🔴)**: Fatores 01-06, 09-11 são bloqueadores de deploy
- **Severidade alta (🟠)**: Fatores 07-08, 12 exigem justificativa se violados

## Exemplos de Uso

### @developer: Verificar conformidade antes de PR
```bash
# Exemplo: verificar Factor 03 (Config)
grep -r "API_KEY\s*=\s*['\"]" src/
# ✅ Zero results = config via env vars
# ❌ Matches found = hardcoded secrets (violação)
```

### @architect: Definir requisitos de infra para nova feature
```markdown
# Feature: Sistema de Notificações
## Twelve-Factor Compliance
- [ ] Factor 04: Email service via env var `EMAIL_SERVICE_URL`
- [ ] Factor 06: Worker stateless (fila externa para jobs)
- [ ] Factor 08: Workers escaláveis independente de web processes
```

### @reviewer: Anotar violação via codetag
```typescript
// FIXME: API key hardcoded — move to process.env.STRIPE_KEY
const stripeKey = "sk_test_<YOUR_KEY_HERE>";
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
