---
name: twelve-factor
description: "12 fatores para aplicações cloud-native (Heroku/SaaS). Use quando @coder verifica conformidade com rules 040-051, ou @architect define requisitos de infraestrutura e deployment."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Metodologia Twelve-Factor App

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao configurar novo projeto cloud-native; ao preparar deployment em produção; ao escalar aplicação horizontalmente; ao debugar divergências dev/prod; ao implementar observabilidade via logs |
| **Prerequisites** | Conceitos básicos de deployment e infraestrutura cloud; rules 040–051 (categoria INFRAESTRUTURA); variáveis de ambiente (`process.env`) |
| **Constraints** | Não aplicar regras de processo (Fator 06, stateless) em ambientes de desenvolvimento local onde combinação build+run é aceitável; não misturar configuração de build (tsconfig.json) com configuração de ambiente (process.env) |
| **Scope** | Os 12 fatores da metodologia Twelve-Factor App mapeados para rules 040–051, com foco em portabilidade, escalabilidade horizontal e deployment contínuo |

---

## O que É

A Twelve-Factor App é uma metodologia para construir aplicações SaaS (Software-as-a-Service) que:

- Usam **configuração declarativa e automação** para setup, minimizando tempo e custo de onboarding
- Têm **máxima portabilidade** entre ambientes de execução
- São adequadas para **deployment em plataformas cloud modernas**
- Minimizam **divergência entre dev e prod**, permitindo **deployment contínuo**
- Podem **escalar horizontalmente** sem mudanças significativas

Criada por desenvolvedores da Heroku, a metodologia sintetiza práticas de centenas de aplicações SaaS em 12 princípios fundamentais.

## Quando Usar

| Cenário | Fator(es) Relevante(s) |
|---------|------------------------|
| Configurar novo projeto | 01-Codebase, 02-Dependencies, 03-Config |
| Preparar deployment em produção | 04-Backing Services, 05-Build/Release/Run |
| Escalar aplicação horizontalmente | 06-Processes, 08-Concurrency |
| Garantir resiliência e recuperação rápida | 09-Disposability |
| Debugar "funciona na minha máquina" | 10-Dev/Prod Parity |
| Implementar observabilidade | 11-Logs |
| Executar migrations/tarefas admin | 12-Admin Processes |
| Port binding e exposição de serviço | 07-Port Binding |

## Os 12 Fatores

| # | Fator | Rule deMGoncalves | Pergunta-Chave | Arquivo de Referência |
|---|-------|-------------------|----------------|---------------------|
| 01 | **Codebase** | [040](../../rules/040_base-codigo-unica.md) | 1 app = 1 repositório? | [01-codebase.md](references/01-codebase.md) |
| 02 | **Dependencies** | [041](../../rules/041_declaracao-explicita-dependencias.md) | Todas as dependências explícitas no manifesto? | [02-dependencies.md](references/02-dependencies.md) |
| 03 | **Config** | [042](../../rules/042_configuracoes-via-ambiente.md) | Config em vars de ambiente (não hardcoded)? | [03-config.md](references/03-config.md) |
| 04 | **Backing Services** | [043](../../rules/043_servicos-apoio-recursos.md) | Serviços anexáveis via URL/config? | [04-backing-services.md](references/04-backing-services.md) |
| 05 | **Build, Release, Run** | [044](../../rules/044_separacao-build-release-run.md) | 3 estágios separados e imutáveis? | [05-build-release-run.md](references/05-build-release-run.md) |
| 06 | **Processes** | [045](../../rules/045_processos-stateless.md) | Processos stateless + share-nothing? | [06-processes.md](references/06-processes.md) |
| 07 | **Port Binding** | [046](../../rules/046_port-binding.md) | App autocontido com servidor HTTP embutido? | [07-port-binding.md](references/07-port-binding.md) |
| 08 | **Concurrency** | [047](../../rules/047_concorrencia-via-processos.md) | Escalar via múltiplos processos? | [08-concurrency.md](references/08-concurrency.md) |
| 09 | **Disposability** | [048](../../rules/048_descartabilidade-processos.md) | Startup rápido + shutdown gracioso? | [09-disposability.md](references/09-disposability.md) |
| 10 | **Dev/Prod Parity** | [049](../../rules/049_paridade-dev-prod.md) | Dev ≈ Staging ≈ Prod (stack + tempo + pessoas)? | [10-dev-prod-parity.md](references/10-dev-prod-parity.md) |
| 11 | **Logs** | [050](../../rules/050_logs-fluxo-eventos.md) | Logs → stdout (não arquivos)? | [11-logs.md](references/11-logs.md) |
| 12 | **Admin Processes** | [051](../../rules/051_processos-administrativos.md) | Tarefas admin = processos one-off? | [12-admin-processes.md](references/12-admin-processes.md) |

## Seleção Rápida por Contexto

### "Preciso configurar um novo projeto"
→ **Começar com**: 01-Codebase, 02-Dependencies, 03-Config

### "Aplicação não escala horizontalmente"
→ **Verificar**: 06-Processes, 08-Concurrency, 09-Disposability

### "Deploy é manual e arriscado"
→ **Verificar**: 05-Build/Release/Run, 10-Dev/Prod Parity

### "Bug funciona em dev, falha em prod"
→ **Verificar**: 03-Config, 04-Backing Services, 10-Dev/Prod Parity

### "Logs perdidos quando container reinicia"
→ **Verificar**: 11-Logs

### "Script de migration quebrou prod mas funciona em dev"
→ **Verificar**: 12-Admin Processes, 10-Dev/Prod Parity

## Proibições

Esta skill detecta e previne:

- **❌ Configurações hardcoded** (viola Fator 03)
- **❌ Dependências implícitas** (viola Fator 02)
- **❌ Estado em memória/filesystem local** (viola Fator 06)
- **❌ Logs em arquivos locais** (viola Fator 11)
- **❌ Scripts admin executados via SSH direto** (viola Fator 12)
- **❌ Servidor web externo obrigatório** (viola Fator 07)
- **❌ Divergência dev/prod em backing services** (viola Fator 10)
- **❌ Processos não descartáveis** (viola Fator 09)

## Justificativa

**Rules deMGoncalves 040–051** implementam os 12 fatores:

- **Infraestrutura (040-051)**: Toda categoria "INFRAESTRUTURA" mapeia 1:1 para um fator
- **Severidade crítica (🔴)**: Fatores 01-06, 09-11 são blockers de deployment
- **Severidade alta (🟠)**: Fatores 07-08, 12 requerem justificativa se violados

## Exemplos de Uso

### @coder: Verificar conformidade antes de PR
```bash
# Exemplo: verificar Fator 03 (Config)
grep -r "API_KEY\s*=\s*['\"]" src/
# ✅ Zero resultados = config via vars de ambiente
# ❌ Matches encontrados = secrets hardcoded (violação)
```

### @architect: Definir requisitos de infra para nova feature
```markdown
# Feature: Sistema de Notificações
## Conformidade Twelve-Factor
- [ ] Fator 04: Serviço de email via var de ambiente `EMAIL_SERVICE_URL`
- [ ] Fator 06: Worker stateless (fila externa para jobs)
- [ ] Fator 08: Workers escaláveis independente de processos web
```

### @architect: Anotar violação via codetag
```typescript
// FIXME: Chave API hardcoded — mover para process.env.STRIPE_KEY
const stripeKey = "sk_test_REDACTED_EXAMPLE";
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
