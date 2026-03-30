# Limite Máximo de Linhas por Arquivo de Classe

**ID**: ESTRUTURAL-007
**Severidade**: 🔴 Crítica
**Categoria**: Estrutural

---

## O que é

Impõe um limite máximo no número de linhas de código em um arquivo de classe (entidade, *service*, controlador), forçando a extração de responsabilidades para outras classes.

*(Previne o anti-pattern Large Class: classe com atributos e métodos demais, indicando responsabilidades excessivas.)*

## Por que importa

A violação do limite de linhas é um forte indicador de que a classe está violando o Princípio da Responsabilidade Única (SRP), resultando em classes com baixa coesão, alto acoplamento e dificuldade extrema na manutenção e testes.

## Critérios Objetivos

- [ ] Arquivos de classe (incluindo declarações, métodos e propriedades) devem ter, no máximo, 50 linhas de código (excluindo linhas em branco e comentários).
- [ ] Classes que atingem 40 linhas devem ser imediatamente candidatas à refatoração.
- [ ] Métodos individuais devem ter, no máximo, 15 linhas de código.

## Exceções Permitidas

- **Classes de Configuração/Inicialização**: Classes que apenas declaram constantes ou mapeamentos (ex: *Mappers*, *Configuration*).
- **Classes de Teste**: *Suites* de teste onde cada método de teste é pequeno, mas o arquivo cresce devido ao número de cenários.

## Como Detectar

### Manual

Contagem visual ou uso de ferramentas de análise de métricas de arquivo.

### Automático

SonarQube/ESLint: `max-lines-per-file: 50` e `max-lines-per-method: 5`.

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [004 - Coleções de Primeira Classe](004_colecoes-primeira-classe.md): reforça
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [021 - Proibição da Duplicação de Lógica](021_proibicao-duplicacao-logica.md): reforça
- [023 - Proibição de Funcionalidade Especulativa](023_proibicao-funcionalidade-especulativa.md): reforça
- [025 - Proibição do Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): reforça
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): complementa
- [055 - Limite Máximo de Linhas por Método](055_limite-maximo-linhas-metodo.md): complementa
- [054 - Proibição de Mudança Divergente](054_proibicao-mudanca-divergente.md): complementa

---

**Criada em**: 2025-10-04
**Versão**: 1.0
