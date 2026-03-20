# Serviços de Apoio como Recursos Anexados

**ID**: INFRASTRUCTURE-043
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Serviços de apoio (bancos de dados, filas, caches, serviços de e-mail, APIs externas) devem ser tratados como **recursos anexados**, acessados via URL ou localizador de recurso armazenado na configuração. A aplicação não deve distinguir entre serviços locais e de terceiros.

## Por que importa

Tratar serviços como recursos anexados permite trocar um banco de dados local por um gerenciado (ex.: RDS), ou um serviço de e-mail por outro, sem alterações no código. Isso aumenta a resiliência e a flexibilidade de deploy.

## Critérios Objetivos

- [ ] Todos os serviços externos devem ser acessados via **URL ou string de conexão** configurável por variável de ambiente.
- [ ] O código não deve conter lógica condicional que diferencie serviços locais de remotos (ex.: `if (isLocal) useLocalDB()`).
- [ ] A troca de um serviço de apoio deve exigir **apenas** alteração de configuração, não alteração de código.

## Exceções Permitidas

- **Mocks de Teste**: Substituição de serviços por mocks em ambiente de teste unitário, controlada via injeção de dependência.

## Como Detectar

### Manual

Verificar se a troca de um serviço (ex.: MySQL por PostgreSQL, ou Redis local por ElastiCache) exige alterações no código.

### Automático

Análise de código: Buscar URLs ou hosts hardcoded, ou condicionais baseados em ambiente.

## Relacionado a

- [014 - Princípio da Inversão de Dependência](005_dependency-inversion-principle.md): reforça
- [042 - Configurações via Ambiente](../twelve-factor/003_configuracoes-via-ambiente.md): complementa
- [049 - Paridade Dev/Prod](../twelve-factor/010_paridade-dev-prod.md): reforça
- [011 - Princípio Aberto/Fechado](002_open-closed-principle.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
