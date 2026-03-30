---
paths:
  - "**/*.yml"
  - "**/*.yaml"
  - "**/*.json"
  - "**/Dockerfile*"
  - "**/docker-compose*"
  - "**/.env*"
  - "**/package.json"
  - "**/tsconfig.json"
---

# Processos Administrativos como One-Off (Admin Processes)

**ID**: INFRAESTRUTURA-051
**Severidade**: 🟠 Alta
**Categoria**: Infraestrutura

---

## O que é

Tarefas administrativas ou de manutenção (migrações de banco, scripts de correção, console REPL) devem ser executadas como **processos one-off** no mesmo ambiente e com o mesmo código da aplicação principal, não como scripts separados ou processos persistentes.

## Por que importa

Processos administrativos executados fora do ambiente da aplicação podem usar versões diferentes do código ou dependências, causando inconsistências. Executar no mesmo contexto garante que migrations e scripts usem exatamente o mesmo código em produção.

## Critérios Objetivos

- [ ] Scripts de migração de banco devem ser executados como processos one-off usando o mesmo runtime e dependências da aplicação.
- [ ] Tarefas administrativas devem estar **versionadas no repositório** junto com o código da aplicação.
- [ ] É proibido executar scripts administrativos via SSH direto no servidor — devem usar o mesmo mecanismo de deploy.

## Exceções Permitidas

- **Ferramentas de Infraestrutura**: Scripts de provisionamento de infraestrutura (Terraform, Ansible) que operam em nível diferente da aplicação.
- **Debugging de Emergência**: Acesso direto ao ambiente em situações críticas de produção, com auditoria.

## Como Detectar

### Manual

Verificar se scripts de migração ou manutenção são executados via processo separado ou via SSH manual.

### Automático

CI/CD: Pipeline que executa migrations como step do deploy, usando mesmo container/ambiente da aplicação.

## Relacionada com

- [040 - Base de Código Única](040_base-codigo-unica.md): reforça
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): reforça
- [044 - Separação Build, Release, Run](044_separacao-build-release-run.md): complementa
- [049 - Paridade Dev/Prod](049_paridade-dev-prod.md): reforça

---

**Criada em**: 2025-01-10
**Versão**: 1.0
