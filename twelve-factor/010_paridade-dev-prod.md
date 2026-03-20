# Paridade Dev/Prod

**ID**: INFRASTRUCTURE-049
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Os ambientes de desenvolvimento, staging e produção devem ser tão **similares quanto possível**. Isso inclui minimizar lacunas de tempo (deploy frequente), lacunas de pessoal (quem desenvolve também faz deploy) e lacunas de ferramentas (mesmas tecnologias em todos os ambientes).

## Por que importa

Divergências entre ambientes causam bugs que só aparecem em produção, dificultando a depuração e tornando os deploys arriscados. A paridade permite que os desenvolvedores confiem que o que funciona localmente funcionará em produção.

## Critérios Objetivos

- [ ] Os mesmos **serviços de apoio** (banco de dados, cache, fila) devem ser usados em dev e prod — é proibido usar SQLite em dev e PostgreSQL em prod.
- [ ] O tempo entre escrever o código e fazer deploy em produção deve ser inferior a **1 dia** (idealmente horas).
- [ ] Containers ou configurações de ambiente devem ser **idênticos** entre dev e prod (ex.: mesmo Dockerfile).

## Exceções Permitidas

- **Escala de Recursos**: Diferenças de escala (menos réplicas, menos CPU/memória) são aceitáveis, desde que a arquitetura seja idêntica.
- **Dados de Teste**: O uso de dados sintéticos ou anonimizados em dev é obrigatório por razões de segurança.

## Como Detectar

### Manual

Comparar o stack de tecnologia e as versões dos serviços entre os ambientes. Verificar se bugs reportados em prod são reproduzíveis em dev.

### Automático

Infrastructure as Code: Comparar manifestos (Terraform, Docker Compose) entre ambientes para detectar divergências.

## Relacionado a

- [042 - Configurações via Ambiente](../twelve-factor/003_configuracoes-via-ambiente.md): reforça
- [043 - Serviços de Apoio como Recursos](../twelve-factor/004_servicos-apoio-recursos.md): reforça
- [044 - Separação Estrita de Build, Release, Run](../twelve-factor/005_separacao-build-release-run.md): reforça
- [032 - Cobertura Mínima de Testes](../clean-code/cobertura-teste-minima-qualidade.md): complementa

---

**Criado em**: 2025-01-10
**Versão**: 1.0
