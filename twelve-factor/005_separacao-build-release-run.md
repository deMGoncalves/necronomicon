# Separação Estrita de Build, Release e Run

**ID**: INFRASTRUCTURE-044
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

O processo de deploy deve ser separado em três estágios distintos e imutáveis: **Build** (compila o código), **Release** (combina build com configuração) e **Run** (executa a aplicação). Cada release deve ter um identificador único e ser imutável.

## Por que importa

A separação permite rollbacks rápidos, auditoria de releases e garante que o código em execução é exatamente o mesmo que foi testado. Misturar estágios cria ambiguidade sobre o que está em execução e impede a reprodutibilidade.

## Critérios Objetivos

- [ ] O estágio de **Build** deve produzir um artefato executável (bundle, imagem de container) sem dependências de configuração de ambiente.
- [ ] O estágio de **Release** deve ser imutável — uma vez criado, o release não pode ser alterado; correções exigem um novo release.
- [ ] Todo release deve ter um **identificador único** (timestamp, hash, número sequencial) para rastreabilidade.

## Exceções Permitidas

- **Ambiente de Desenvolvimento Local**: Build e run podem ser combinados para agilizar o ciclo de desenvolvimento (ex.: `bun run dev`).

## Como Detectar

### Manual

Verificar se é possível alterar código ou configuração de um release já em produção sem criar um novo release.

### Automático

CI/CD: Pipeline que rejeita deploys manuais e exige a passagem pelos três estágios com versionamento.

## Relacionado a

- [040 - Base de Código Única](../twelve-factor/001_base-codigo-unica.md): complementa
- [041 - Declaração Explícita de Dependências](../twelve-factor/002_declaracao-explicita-dependencias.md): reforça
- [042 - Configurações via Ambiente](../twelve-factor/003_configuracoes-via-ambiente.md): complementa
- [049 - Paridade Dev/Prod](../twelve-factor/010_paridade-dev-prod.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
