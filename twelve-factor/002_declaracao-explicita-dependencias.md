# Declaração Explícita de Dependências

**ID**: INFRASTRUCTURE-041
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Uma aplicação deve declarar **todas** as suas dependências de forma explícita e completa por meio de um manifesto de dependências (ex.: `package.json`, `requirements.txt`). A aplicação nunca deve depender da existência implícita de pacotes no sistema.

## Por que importa

Dependências implícitas quebram a portabilidade e a reprodutibilidade do ambiente. Um novo desenvolvedor ou um novo servidor não conseguirá executar a aplicação sem conhecimento prévio das dependências ocultas, violando o princípio de *setup* mínimo.

## Critérios Objetivos

- [ ] **100%** das dependências de runtime e build devem ser declaradas no manifesto (`package.json`, `bun.lockb`).
- [ ] É proibido o uso de dependências globais do sistema (ex.: bibliotecas instaladas via `npm install -g` ou `apt-get`).
- [ ] O *lockfile* de dependências deve ser versionado e mantido atualizado para garantir builds determinísticos.

## Exceções Permitidas

- **Runtime Base**: Dependências fundamentais de runtime (ex.: Node.js, Bun, Python) que são declaradas como requisitos do ambiente.

## Como Detectar

### Manual

Clonar o repositório em uma máquina limpa e executar `npm install && npm start` — se falhar por dependência ausente, há uma violação.

### Automático

CI/CD: Builds em containers efêmeros (Docker) que falham se houver dependências não declaradas.

## Relacionado a

- [014 - Princípio da Inversão de Dependência](005_dependency-inversion-principle.md): complementa
- [018 - Princípio das Dependências Acíclicas](004_acyclic-dependencies-principle.md): reforça
- [042 - Configurações via Ambiente](../twelve-factor/003_configuracoes-via-ambiente.md): complementa
- [044 - Separação Estrita de Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
