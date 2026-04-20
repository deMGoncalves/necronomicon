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

# Paridade entre Desenvolvimento e Produção (Dev/Prod Parity)

**ID**: INFRAESTRUTURA-049
**Severidade**: 🔴 Crítica
**Categoria**: Infraestrutura

---

## O que é

Os ambientes de desenvolvimento, staging e produção devem ser o mais **similares possível**. Isso inclui minimizar gaps de tempo (deploy frequente), gaps de pessoal (quem desenvolve também faz deploy), e gaps de ferramentas (mesmas tecnologias em todos os ambientes).

## Por que importa

Divergências entre ambientes causam bugs que só aparecem em produção, tornando debugging difícil e deploys arriscados. A paridade permite que desenvolvedores confiem que o que funciona localmente funcionará em produção.

## Critérios Objetivos

- [ ] Os mesmos **serviços de apoio** (banco de dados, cache, fila) devem ser usados em dev e prod — é proibido usar SQLite em dev e PostgreSQL em prod.
- [ ] O tempo entre escrever código e fazer deploy em produção deve ser inferior a **1 dia** (idealmente horas).
- [ ] Containers ou configurações de ambiente devem ser **idênticos** entre dev e prod (ex: mesmo Dockerfile).

## Exceções Permitidas

- **Escala de Recursos**: Diferenças de escala (menos réplicas, menor CPU/memória) são aceitáveis desde que a arquitetura seja idêntica.
- **Dados de Teste**: Uso de dados sintéticos ou anonimizados em dev é obrigatório por razões de segurança.

## Como Detectar

### Manual

Comparar stack tecnológica e versões de serviços entre ambientes. Verificar se bugs reportados em prod são reproduzíveis em dev.

### Automático

Infrastructure as Code: Comparar manifests (Terraform, Docker Compose) entre ambientes para detectar divergências.

## Relacionada com

- [042 - Configurações via Ambiente](042_configuracoes-via-ambiente.md): reforça
- [043 - Serviços de Apoio como Recursos](043_servicos-apoio-recursos.md): reforça
- [044 - Separação Build, Release, Run](044_separacao-build-release-run.md): reforça
- [032 - Cobertura Mínima de Teste](032_cobertura-teste-minima-qualidade.md): complementa

---

**Criada em**: 2025-01-10
**Versão**: 1.0
