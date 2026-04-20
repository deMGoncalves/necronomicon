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

# Base de Código Única (Codebase)

**ID**: INFRAESTRUTURA-040
**Severidade**: 🔴 Crítica
**Categoria**: Infraestrutura

---

## O que é

Uma aplicação deve ter exatamente uma base de código rastreada em controle de versão, com múltiplos *deploys* originados dessa mesma base. A relação entre codebase e aplicação é sempre 1:1.

## Por que importa

Múltiplas bases de código para a mesma aplicação indicam um sistema distribuído, não uma aplicação. Código compartilhado deve ser extraído em bibliotecas e gerenciado via dependências. A violação dificulta rastreabilidade, versionamento e manutenção.

## Critérios Objetivos

- [ ] A aplicação deve ter **um único repositório** de código-fonte, com branches para diferentes estágios (dev, staging, prod).
- [ ] Código compartilhado entre aplicações deve ser extraído para **bibliotecas independentes** com versionamento próprio.
- [ ] É proibido copiar código entre repositórios de aplicações diferentes (*copy-paste deployment*).

## Exceções Permitidas

- **Monorepos Organizacionais**: Múltiplas aplicações em um único repositório, desde que cada aplicação tenha seu próprio diretório raiz e pipeline de deploy independente.

## Como Detectar

### Manual

Verificar se existem múltiplos repositórios com código duplicado ou se a mesma funcionalidade é mantida em locais diferentes.

### Automático

Git: Análise de histórico de commits e branches para identificar divergências não intencionais.

## Relacionada com

- [021 - Proibição da Duplicação de Lógica](021_proibicao-duplicacao-logica.md): reforça
- [015 - Princípio de Lançamento e Reuso](015_principio-equivalencia-lancamento-reuso.md): reforça
- [044 - Separação Build, Release, Run](044_separacao-build-release-run.md): complementa

---

**Criada em**: 2025-01-10
**Versão**: 1.0
