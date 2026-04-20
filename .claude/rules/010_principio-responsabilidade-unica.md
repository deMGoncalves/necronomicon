# Aplicação do Princípio da Responsabilidade Única (SRP)

**ID**: COMPORTAMENTAL-010
**Severidade**: 🔴 Crítica
**Categoria**: Comportamental

---

## O que é

Exige que uma classe ou módulo tenha apenas uma razão para mudar, o que implica que deve ter uma única responsabilidade.

## Por que importa

A violação do SRP causa **baixa coesão** e **alto acoplamento**, tornando as classes frágeis e difíceis de testar. Aumenta o custo de manutenção, pois uma mudança em uma área de negócio pode quebrar outra.

## Critérios Objetivos

- [ ] Uma classe não deve conter lógica de negócio e lógica de persistência (ex: *Service* e *Repository* juntos).
- [ ] O número de métodos públicos de uma classe não deve exceder **7**.
- [ ] O **Lack of Cohesion in Methods (LCOM)** deve ser inferior a 0.75.

## Exceções Permitidas

- **Classes de Utilidade/Helpers**: Classes estáticas que agrupam funções puras sem estado para manipulação de dados genéricos (ex: formatadores de data).

## Como Detectar

### Manual

Perguntar: "Se houver uma mudança no requisito X e no requisito Y, esta classe precisa ser alterada em ambas as situações?" (SRP violado se a resposta for sim).

### Automático

SonarQube: Alta `Cognitive Complexity` e `LCOM (Lack of Cohesion in Methods)` alto.

## Relacionada com

- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [004 - Coleções de Primeira Classe](004_colecoes-primeira-classe.md): reforça
- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): complementa
- [025 - Proibição do Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): complementa
- [021 - Proibição da Duplicação de Lógica](021_proibicao-duplicacao-logica.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [015 - Princípio de Equivalência de Lançamento e Reuso](015_principio-equivalencia-lancamento-reuso.md): reforça
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [032 - Cobertura Mínima de Teste](032_cobertura-teste-minima-qualidade.md): reforça
- [033 - Limite de Parâmetros por Função](033_limite-parametros-funcao.md): reforça
- [034 - Nomes de Classes e Métodos Consistentes](034_nomes-classes-metodos-consistentes.md): reforça
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça
- [038 - Princípio de Separação de Comando-Consulta](038_conformidade-principio-inversao-consulta.md): reforça
- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): complementa
- [047 - Concorrência via Processos](047_concorrencia-via-processos.md): complementa
- [054 - Proibição de Mudança Divergente](054_proibicao-mudanca-divergente.md): reforça
- [058 - Proibição de Shotgun Surgery](058_proibicao-shotgun-surgery.md): reforça

---

**Criada em**: 2025-10-04
**Versão**: 1.0
