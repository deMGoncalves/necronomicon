# Processos Administrativos como One-Off

**ID**: INFRASTRUCTURE-051
**Severidade**: 🟠 Alto
**Categoria**: Infraestrutura

---

## O que é

Tarefas administrativas ou de manutenção (migrações de banco de dados, scripts de correção, console REPL) devem ser executadas como **processos one-off** no mesmo ambiente e com o mesmo código da aplicação principal, não como scripts separados ou processos persistentes.

## Por que importa

Processos administrativos executados fora do ambiente da aplicação podem usar versões diferentes de código ou dependências, causando inconsistências. Executar no mesmo contexto garante que migrações e scripts usem exatamente o mesmo código em produção.

## Critérios Objetivos

- [ ] Scripts de migração de banco de dados devem ser executados como processos one-off usando o mesmo runtime e dependências da aplicação.
- [ ] Tarefas administrativas devem ser **versionadas no repositório** junto com o código da aplicação.
- [ ] É proibido executar scripts administrativos via SSH diretamente no servidor — devem usar o mesmo mecanismo de deploy.

## Exceções Permitidas

- **Ferramentas de Infraestrutura**: Scripts de provisionamento de infraestrutura (Terraform, Ansible) que operam em um nível diferente da aplicação.
- **Debugging de Emergência**: Acesso direto ao ambiente em situações críticas de produção, com auditoria.

## Como Detectar

### Manual

Verificar se scripts de migração ou manutenção são executados via processo separado ou SSH manual.

### Automático

CI/CD: Pipeline que executa migrações como etapa de deploy, usando o mesmo container/ambiente da aplicação.

## Relacionado a

- [040 - Base de Código Única](../twelve-factor/001_base-codigo-unica.md): reforça
- [041 - Declaração Explícita de Dependências](../twelve-factor/002_declaracao-explicita-dependencias.md): reforça
- [044 - Separação Estrita de Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): complementa
- [049 - Paridade Dev/Prod](../twelve-factor/010_paridade-dev-prod.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
