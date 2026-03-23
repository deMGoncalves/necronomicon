---
titulo: Fundamentos de Carga Cognitiva
aliases:
  - Cognitive Load Theory
  - CLT
  - Lei de Miller
  - Carga Cognitiva Intrínseca
tipo: conceito
origem: cdd
tags:
  - cdd
  - psicologia-cognitiva
  - carga-cognitiva
  - miller
  - sweller
relacionados:
  - "[[metodologia-cdd]]"
  - "[[calculo-icp]]"
criado: 2026-03-23
---

# Fundamentos de Carga Cognitiva

*Cognitive Load Theory — John Sweller (1988) | Lei de Miller — George Miller (1956)*

---

## Definição

**Carga cognitiva** é o esforço mental exigido pela memória de trabalho ao processar informações. No contexto de código, é a quantidade de conceitos, relações e estruturas que um desenvolvedor precisa manter em mente simultaneamente para compreender e modificar uma unidade de código.

O CDD utiliza a Teoria da Carga Cognitiva como fundamento científico para justificar por que código complexo é mais custoso — não apenas subjetivamente, mas de forma mensurável e previsível.

## A Lei de Miller (1956)

George Miller publicou em 1956 o paper *"The Magical Number Seven, Plus or Minus Two"*, demonstrando que a memória de trabalho humana consegue processar, em média, **7 ± 2 chunks de informação** simultaneamente.

Um *chunk* é qualquer unidade de informação que o cérebro reconhece como uma única peça — pode ser uma variável simples, uma condição `if`, ou um conceito complexo já internalizado.

**Refinamento contemporâneo:** pesquisa cognitiva posterior revelou capacidades ainda mais limitadas:

| Contexto | Capacidade |
|---|---|
| Retenção simples | 7 ± 2 elementos |
| Manipulação ativa | **4 ± 1 elementos** |
| Processamento complexo | 2–3 elementos |

O cenário de code review envolve **manipulação ativa** (entender, avaliar e rastrear fluxo), portanto o limite real relevante é **4 ± 1** — não 7. Isso justifica por que um método com ICP = 5 já começa a sobrecarregar a memória de trabalho.

**Implicação para código:**

```javascript
// ❌ 9+ chunks para processar simultaneamente
function process(d, f, t, opts) {
  return f ? d.filter(i => i.t === t && i.v > opts.min)
              .map(i => ({ ...i, v: i.v * opts.rate }))
           : d.map(i => i.t === t ? { ...i, v: i.v * opts.rate } : i);
}

// ✅ 2-3 chunks por vez — leitura sequencial natural
function processItems(items, shouldFilter, type, options) {
  if (shouldFilter) {
    return filterAndTransform(items, type, options);
  }
  return transformMatching(items, type, options);
}
```

## Teoria da Carga Cognitiva (Sweller, 1988)

John Sweller desenvolveu a teoria no final dos anos 1980, originalmente através de pesquisa em resolução de problemas. Os três tipos de carga são **aditivos** — somam-se na memória de trabalho.

### 1. Carga Intrínseca (*Intrinsic Load*)

Imposta pela **complexidade inerente do problema** — o número de elementos que precisam ser processados simultaneamente e suas interdependências. **Esta é a carga que o CDD mede e limita via ICP.**

> "A carga é chamada 'intrínseca' se imposta pelo número de elementos de informação e sua interatividade." — John Sweller

Exemplo: traduzir palavras isoladas tem carga intrínseca menor do que traduzir frases completas (requer análise de significados *e* de relacionamentos gramaticais). No código:
- Múltiplos caminhos de execução (`if/else` aninhados)
- Muitas variáveis de estado em um único método
- Dependências implícitas entre partes do código

**Não pode ser completamente eliminada** sem simplificar o problema em si — mas pode ser *distribuída* entre funções menores.

### 2. Carga Extrínseca (*Extraneous Load*)

Carga desnecessária imposta por **como a informação é apresentada**, não pela complexidade intrínseca. No código:

- Nomes abreviados ou enganosos (`u` em vez de `user`, `d` em vez de `data`)
- Código duplicado que obriga o desenvolvedor a verificar se são realmente idênticos
- Comentários que contradizem o código

**Pode e deve ser eliminada** pelas rules de Clean Code. Reduzir a carga extrínseca libera capacidade de trabalho para a carga intrínseca real do problema.

### 3. Carga Germânica (*Germane Load*)

Esforço cognitivo **direcionado ativamente à construção de esquemas mentais** — o aprendizado real. No código, é o esforço de internalizar um padrão de design, entender a arquitetura de um domínio, ou construir um modelo mental do sistema.

Esta carga é **desejável**: quando cargas intrínseca e extrínseca são controladas, mais capacidade cognitiva fica disponível para construção de conhecimento (germane load). Instrução eficaz — e código bem estruturado — estimula este tipo de carga.

### Propriedade Aditiva

```
Carga Total = Intrínseca + Extrínseca + Germânica ≤ Capacidade da Memória de Trabalho
```

Se intrínseca + extrínseca já consomem toda a capacidade, não sobra espaço para aprendizado (germânica). O CDD busca reduzir a intrínseca ao mínimo necessário e eliminar a extrínseca, maximizando o espaço disponível para o desenvolvedor construir conhecimento sobre o domínio.

## Por que Isso Importa para Código

| Situação | Carga Cognitiva | Consequência |
|---|---|---|
| Método com CC = 12 | Muito alta | Desenvolvedor constrói modelo mental incorreto → bug |
| Método com 4+ níveis de aninhamento | Alta | Desenvolvedor perde rastreamento do fluxo → erro lógico |
| Função com 6 responsabilidades | Alta | Desenvolvedor não sabe onde adicionar nova lógica → duplicação |
| Método com 8 dependências | Moderada | Setup de teste complexo → cobertura baixa → regressões |

## Carga Cognitiva vs. Complexidade Ciclomática

A Complexidade Ciclomática (CC) mede **caminhos de execução**. A carga cognitiva mede **esforço mental**. São correlacionadas, mas diferentes:

```javascript
// CC = 4 (4 ifs + 1), mas BAIXA carga cognitiva
// Padrão de guard clause — leitura linear e previsível
function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  if (!user.name) return false;
  return true;
}

// CC = 4 (4 ifs + 1), mas ALTA carga cognitiva
// Aninhamento força o desenvolvedor a rastrear múltiplos estados
function validateUser(user) {
  if (user) {
    if (user.email) {
      if (user.name) {
        return true;
      }
    }
  }
  return false;
}
```

O ICP captura essa diferença: o segundo exemplo tem **Aninhamento = 3 níveis → +2 pontos de ICP**, enquanto o primeiro tem **Aninhamento = 1 nível → +0 pontos**.

## Aplicação no CDD

O CDD operacionaliza a Teoria da Carga Cognitiva em código através do **ICP** (Intrinsic Complexity Points):

- **CC_base** → mede carga intrínseca via caminhos de execução
- **Aninhamento** → mede carga intrínseca via profundidade de estrutura
- **Responsabilidades** → mede carga intrínseca via número de conceitos simultâneos
- **Acoplamento** → mede carga extrínseca via dependências que o desenvolvedor precisa conhecer

A meta de **ICP ≤ 5** por método não é arbitrária: reflete a capacidade média da memória de trabalho humana segundo Miller.

## Relacionados

- [[metodologia-cdd]] — como os fundamentos se traduzem em metodologia prática
- [[calculo-icp]] — a operacionalização da carga cognitiva em métrica
- [[componente-cc-base]] — carga intrínseca via complexidade ciclomática
- [[componente-aninhamento]] — carga intrínseca via profundidade de estrutura
- [[componente-responsabilidades]] — carga intrínseca via múltiplos conceitos
- [[componente-acoplamento]] — carga extrínseca via dependências externas
