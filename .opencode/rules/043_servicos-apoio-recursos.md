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

# Serviços de Apoio como Recursos Anexáveis (Backing Services)

**ID**: INFRAESTRUTURA-043
**Severidade**: 🔴 Crítica
**Categoria**: Infraestrutura

---

## O que é

Serviços de apoio (bancos de dados, filas, caches, serviços de email, APIs externas) devem ser tratados como **recursos anexáveis**, acessados via URL ou localizador de recurso armazenado em configuração. A aplicação não deve distinguir entre serviços locais e de terceiros.

## Por que importa

Tratar serviços como recursos anexáveis permite trocar um banco de dados local por um gerenciado (ex: RDS), ou um serviço de email por outro, sem alteração de código. Isso aumenta a resiliência e flexibilidade de deploy.

## Critérios Objetivos

- [ ] Todos os serviços externos devem ser acessados via **URL ou string de conexão** configurável por variável de ambiente.
- [ ] O código não deve conter lógica condicional que diferencie serviços locais de remotos (ex: `if (isLocal) useLocalDB()`).
- [ ] A troca de um serviço de apoio deve exigir **apenas** alteração de configuração, não de código.

## Exceções Permitidas

- **Mocks de Teste**: Substituição de serviços por mocks em ambiente de teste unitário, controlada via injeção de dependência.

## Como Detectar

### Manual

Verificar se a troca de um serviço (ex: MySQL para PostgreSQL, ou Redis local para ElastiCache) exige alteração de código.

### Automático

Análise de código: Busca por URLs ou hosts hardcoded, ou por condicionais baseados em ambiente.

## Relacionada com

- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): reforça
- [042 - Configurações via Ambiente](042_configuracoes-via-ambiente.md): complementa
- [049 - Paridade Dev/Prod](049_paridade-dev-prod.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): reforça

---

**Criada em**: 2025-01-10
**Versão**: 1.0
