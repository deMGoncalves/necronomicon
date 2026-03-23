---
titulo: Metodologia CDD
aliases:
  - CDD Methodology
  - Cognitive-Driven Development Methodology
tipo: conceito
origem: cdd
tags:
  - cdd
  - metodologia
  - code-review
  - icp
relacionados:
  - "[[fundamentos-carga-cognitiva]]"
  - "[[calculo-icp]]"
  - "[[aplicacao-code-review]]"
criado: 2026-03-23
---

# Metodologia CDD

*Cognitive-Driven Development — Zup Innovation (2020)*

---

## Definição

CDD (Cognitive-Driven Development) é uma metodologia de desenvolvimento de software que orienta as decisões de design e revisão de código pela **carga cognitiva** que o código impõe ao desenvolvedor — não apenas por convenções estilísticas ou heurísticas subjetivas.

Criada pela **Zup Innovation** (Brasil) a partir de pesquisa empírica com times de engenharia, o CDD fornece uma linguagem comum e uma métrica objetiva ([[calculo-icp|ICP]]) para discutir qualidade de código em code reviews.

## Origem e Contexto

O CDD surgiu da observação de que revisões de código frequentemente degeneravam em debates subjetivos sobre estilo, sem consenso sobre o que tornava o código *realmente* mais difícil de manter. A Zup Innovation buscou uma abordagem baseada em ciência cognitiva — especificamente na [[fundamentos-carga-cognitiva|Teoria da Carga Cognitiva de Sweller]] — para objetivar essa discussão.

Resultado: dois papers acadêmicos revisados por pares documentando os resultados empíricos da aplicação do CDD em times reais de engenharia de software.

## Princípio Central

> **Código é lido 10 vezes mais do que é escrito.** Portanto, a métrica primária de qualidade de código deve ser a facilidade de leitura e compreensão — não a facilidade de escrita.

Isso implica três prioridades:
- **Legibilidade > Concisão**: um código de 5 linhas que exige 30 segundos para entender é pior que um de 10 linhas que se lê em 5 segundos
- **Clareza > Esperteza**: código "inteligente" que surpreende o leitor é um bug esperando para acontecer
- **Explícito > Implícito**: dependências e comportamentos ocultos aumentam a carga cognitiva de forma desproporcional

## Os Três Pilares

### Pilar 1 — Complexidade Cognitiva > Complexidade Ciclomática

A Complexidade Ciclomática (CC) mede caminhos de execução, mas não captura a **dificuldade real de leitura**. Dois métodos com a mesma CC podem ter cargas cognitivas radicalmente diferentes dependendo de como o código está estruturado (aninhamento, responsabilidades, nomes).

O CDD usa o **ICP** como métrica composta que captura essa diferença.

> A **unidade primária de medição preferida no CDD é o arquivo** — não o método. Isso permite medir a carga cognitiva acumulada de uma unidade de trabalho completa, que é o que o desenvolvedor precisa compreender para realizar uma tarefa.

### Pilar 2 — Métricas Objetivas, Acordadas pelo Time

Em vez de "esse código está confuso", o CDD permite dizer "esse arquivo tem ICP = 12 — acima do limite de 7 acordado pelo time". A objetividade elimina o debate subjetivo e foca na solução.

**O CDD não é prescritivo:** cada time define, por consenso, quais fatores contam para a carga cognitiva e quais são os limites aceitáveis — considerando a linguagem, o domínio e a maturidade da equipe. Os valores usados neste vault (ICP ≤ 5 por método, ICP ≤ 10 como limite absoluto) são pontos de partida baseados em Miller's Law, não regras universais.

### Pilar 3 — Calibração Contextual

O CDD não é prescritivo: ele fornece métricas, mas reconhece que o contexto importa. Um hotfix crítico com ICP = 7 pode ser aceitável se a alternativa é uma refatoração de 2 dias em produção instável. A metodologia ensina o desenvolvedor a calibrar, não apenas a medir.

## Implementação em Times

O CDD recomenda uma adoção incremental em 5 etapas:

1. **Análise empírica** — medir a carga cognitiva atual do codebase para ter uma baseline
2. **Acordo explícito** — o time define consensualmente quais fatores contam como complexidade e os limites aceitáveis
3. **Integração em code review** — usar ICP como critério objetivo nas revisões (ver [[aplicacao-code-review]])
4. **Refatoração incremental** — reduzir o ICP de arquivos/métodos críticos progressivamente
5. **Monitoramento** — acompanhar a evolução do ICP médio do projeto ao longo do tempo

## As Três Camadas de Análise

O CDD opera em três camadas aplicadas sequencialmente em um code review:

### Camada 1 — Análise de ICP

Quantifica a **complexidade cognitiva intrínseca** do código usando a fórmula:

```
ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento
```

Meta: ICP ≤ 5 para a maioria dos métodos, ICP ≤ 10 como limite absoluto.

### Camada 2 — Validação de Rules

Verifica conformidade com **regras arquiteturais** categorizadas em:
- **Estruturais** — layout, organização, nomenclatura (ex.: [[restricao-imports-relativos|Path Aliases]], [[proibicao-nomes-enganosos|Nomes Enganosos]])
- **Comportamentais** — princípios SOLID, design patterns (ex.: [[conformidade-principio-inversao-consulta|CQS]], [[restricao-funcoes-efeitos-colaterais|Side Effects]])
- **Criacionais** — encapsulamento, imutabilidade (ex.: [[imutabilidade-objetos-freeze|Object.freeze]])

### Camada 3 — Identificação de Padrões

Identifica oportunidades de aplicar padrões conhecidos (GoF, PoEAA) para substituir implementações ad hoc com alta carga cognitiva por soluções familiares e testadas.

## Métricas de Sucesso

### Para o Código

| Métrica | Meta |
|---|---|
| ICP médio do projeto | ≤ 4 |
| Métodos com ICP > 10 | 0% |
| Conformidade com rules críticas | ≥ 80% |
| Cobertura de testes em módulos de domínio | ≥ 85% |

### Para o Time

- **Redução de bugs** em código com ICP baixo ao longo do tempo
- **Aumento de velocidade** em modificações de código com ICP ≤ 3
- **Redução de dívida técnica** medida por decréscimo do ICP médio do projeto a cada sprint

## Anti-Padrões de Aplicação

### Perfeccionismo Paralisante
❌ Bloquear PRs por ICP = 6 em código de baixo risco com prazo iminente
✅ Registrar como dívida técnica e agendar refatoração

### Rigidez de Rules
❌ Exigir ICP ≤ 3 em todos os métodos sem exceção
✅ Calibrar limites por criticidade, frequência de mudança e risco

### Análise Superficial
❌ Verificar apenas formatação e style sem calcular ICP
✅ Analisar CC, aninhamento e responsabilidades em métodos com mais de 10 linhas

### Falta de Pragmatismo
❌ Recusar features prontas por violações de ICP em código não-crítico
✅ Aceitar código com ICP aceitável (4-6) que entrega valor imediato

## Relacionados

- [[fundamentos-carga-cognitiva]] — a base teórica da metodologia
- [[calculo-icp]] — a métrica central do CDD
- [[aplicacao-code-review]] — o processo passo a passo em code reviews
- [[clean-code|Clean Code]] — rules que reduzem ICP na prática
