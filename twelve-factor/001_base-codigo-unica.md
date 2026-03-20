# Base de Código Única

**ID**: INFRASTRUCTURE-040
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Uma aplicação deve ter exatamente uma base de código rastreada no controle de versão, com múltiplos *deploys* originando dessa mesma base. A relação entre base de código e aplicação é sempre 1:1.

## Por que importa

Múltiplas bases de código para a mesma aplicação indicam um sistema distribuído, não uma aplicação. Código compartilhado deve ser extraído para bibliotecas e gerenciado via dependências. A violação dificulta a rastreabilidade, o versionamento e a manutenção.

## Critérios Objetivos

- [ ] A aplicação deve ter **um único repositório** de código-fonte, com branches para diferentes estágios (dev, staging, prod).
- [ ] Código compartilhado entre aplicações deve ser extraído para **bibliotecas independentes** com seu próprio versionamento.
- [ ] É proibida a cópia de código entre repositórios de aplicações diferentes (*copy-paste deployment*).

## Exceções Permitidas

- **Monorepos Organizacionais**: Múltiplas aplicações em um único repositório, desde que cada aplicação tenha seu próprio diretório raiz e pipeline de deploy independente.

## Como Detectar

### Manual

Verificar se há múltiplos repositórios com código duplicado ou se a mesma funcionalidade é mantida em locais diferentes.

### Automático

Git: Análise do histórico de commits e branches para identificar divergências não intencionais.

## Relacionado a

- [021 - Proibição de Duplicação de Lógica](../clean-code/proibicao-duplicacao-logica.md): reforça
- [015 - Princípio da Equivalência de Reutilização de Release](001_release-reuse-equivalency-principle.md): reforça
- [044 - Separação Estrita de Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): complementa

---

**Criado em**: 2025-01-10
**Versão**: 1.0
