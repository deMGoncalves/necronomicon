# Limite Máximo de Linhas por Arquivo de Classe

**ID**: STRUCTURAL-007
**Severity**: 🔴 Critical
**Category**: Structural

---

## O que é

Impõe um limite máximo no número de linhas de código em um arquivo de classe (entidade, *service*, controller), forçando a extração de responsabilidades para outras classes.

## Por que importa

A violação do limite de linhas é um forte indicador de que a classe está violando o Princípio da Responsabilidade Única (SRP), resultando em classes com baixa coesão, alto acoplamento e extrema dificuldade de manutenção e testes.

## Critérios Objetivos

- [ ] Arquivos de classe (incluindo declarações, métodos e propriedades) devem ter no máximo 50 linhas de código (excluindo linhas em branco e comentários).
- [ ] Classes que atingem 40 linhas devem ser candidatas imediatas a refatoração.
- [ ] Métodos individuais devem ter no máximo 15 linhas de código.

## Exceções Permitidas

- **Classes de Configuração/Inicialização**: Classes que apenas declaram constantes ou mapeamentos (por exemplo, *Mappers*, *Configuration*).
- **Classes de Teste**: *Suites* de teste onde cada método de teste é pequeno, mas o arquivo cresce devido ao número de cenários.

## Como Detectar

### Manual

Contagem visual ou uso de ferramentas de análise de métricas de arquivo.

### Automático

SonarQube/ESLint: `max-lines-per-file: 50` e `max-lines-per-method: 5`.

## Relacionado a

- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): reforça
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): reforça
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reforça
- [021 - Prohibition of Logic Duplication](../clean-code/proibicao-duplicacao-logica.md): reforça
- [023 - Prohibition of Speculative Functionality](../clean-code/proibicao-funcionalidade-especulativa.md): reforça
- [025 - Prohibition of The Blob Anti-Pattern](../clean-code/proibicao-anti-padrao-blob.md): reforça
- [016 - Common Closure Principle](002_common-closure-principle.md): reforça
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
