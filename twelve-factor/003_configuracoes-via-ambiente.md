# Configurações via Variáveis de Ambiente

**ID**: INFRASTRUCTURE-042
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Todas as configurações que variam entre ambientes (*deploy*) devem ser armazenadas em **variáveis de ambiente**, não em arquivos de configuração versionados ou hardcoded no código. Isso inclui credenciais, URLs de serviços e feature flags.

## Por que importa

Configurações hardcoded ou em arquivos versionados criam risco de vazamento de credenciais, impedem deploys flexíveis e violam a separação entre código e configuração. Variáveis de ambiente permitem que o mesmo código seja executado em qualquer ambiente.

## Critérios Objetivos

- [ ] Credenciais (chaves de API, senhas, tokens) devem ser acessadas **exclusivamente** via `process.env` ou equivalente.
- [ ] É proibido o versionamento de arquivos `.env` com valores reais de produção ou staging.
- [ ] O código deve funcionar com **zero** arquivos de configuração específicos de ambiente no repositório.

## Exceções Permitidas

- **Configurações de Desenvolvimento**: Arquivo `.env.example` com valores de exemplo para documentação.
- **Configurações Estruturais**: Arquivos de configuração de build (`tsconfig.json`, `biome.json`) que não variam entre deploys.

## Como Detectar

### Manual

Buscar strings de conexão, URLs de API ou credenciais hardcoded no código-fonte.

### Automático

ESLint: Regras customizadas para detectar strings que parecem credenciais. Git-secrets ou Gitleaks para varredura de segredos.

## Relacionado a

- [030 - Proibição de Funções Inseguras](../clean-code/proibicao-funcoes-inseguras.md): reforça
- [024 - Proibição de Constantes Mágicas](../clean-code/proibicao-constantes-magicas.md): reforça
- [041 - Declaração Explícita de Dependências](../twelve-factor/002_declaracao-explicita-dependencias.md): complementa
- [043 - Serviços de Apoio como Recursos](../twelve-factor/004_servicos-apoio-recursos.md): complementa
- [049 - Paridade Dev/Prod](../twelve-factor/010_paridade-dev-prod.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
