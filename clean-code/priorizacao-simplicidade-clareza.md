---
titulo: Priorização de Simplicidade e Clareza (Princípio KISS)
aliases:
  - KISS — Keep It Simple, Stupid
  - Keep It Simple, Stupid
tipo: rule
id: CC-02
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - estrutural
  - kiss
  - complexidade
resolver: Sprint atual
relacionados:
  - "[[001_single-indentation-level]]"
  - "[[001_single-responsibility-principle]]"
  - "[[005_method-chaining-restriction]]"
  - "[[006_prohibition-abbreviated-names]]"
  - "[[007_maximum-lines-per-class]]"
  - "[[proibicao-duplicacao-logica]]"
  - "[[qualidade-comentarios-porque]]"
criado: 2025-10-08
---

# Priorização de Simplicidade e Clareza (Princípio KISS)

*KISS — Keep It Simple, Stupid*

![KISS Principle](https://www.youtube.com/watch?v=HmBG-1cdHUw)

---

## Definição

Requer que o design e o código sejam mantidos tão simples e diretos quanto possível, evitando soluções excessivamente inteligentes ou complexas quando uma alternativa clara existe.

## Motivação

A complexidade desnecessária é uma dívida que afeta a legibilidade e a manutenibilidade. Soluções simples são mais fáceis de entender, testar, depurar e escalar, reduzindo a tendência a erros e o custo cognitivo.

## Quando Aplicar

- [ ] O **Índice de Complexidade Ciclomática (CC)** de qualquer método não deve exceder **5**.
- [ ] Funções e métodos devem realizar apenas uma única tarefa.
- [ ] O uso de metaprogramação ou recursos avançados da linguagem é proibido quando o mesmo resultado pode ser alcançado com código direto.

## Quando NÃO Aplicar

- **Bibliotecas de Infraestrutura**: Componentes de baixo nível (ex.: *parser*, *serializer*) onde a complexidade é inerente à tarefa, mas isolada.

## Violação — Exemplo

```javascript
// ❌ "Esperteza" desnecessária — difícil de entender à primeira leitura
const getDiscount = (u) =>
  u?.premium && u?.purchases > 10 ? (u?.vip ? 0.3 : 0.2) : u?.purchases > 5 ? 0.1 : 0;
```

## Conformidade — Exemplo

```javascript
// ✅ Legível, direto e com CC baixo
function getDiscount(user) {
  if (!user) return 0;
  if (user.premium && user.vip && user.purchases > 10) return 0.3;
  if (user.premium && user.purchases > 10) return 0.2;
  if (user.purchases > 5) return 0.1;
  return 0;
}
```

## Anti-Patterns Relacionados

- [[overengineering|Overengineering]] — adicionar complexidade sem necessidade real
- [[clever-code|Clever Code]] — código "inteligente" que sacrifica legibilidade por concisão

## Como Detectar

### Manual

Verificar se o código requer mais de 5 segundos de análise para entender seu propósito e fluxo de controle.

### Automático

Biome: [`noExcessiveCognitiveComplexity`](https://biomejs.dev/linter/rules/no-excessive-cognitive-complexity/) com limite configurável via `maxAllowedComplexity`.

## Relação com ICP

Impacta diretamente o **[[componente-cc-base|CC_base]]** (limite de CC = 5) e o **[[componente-aninhamento|Aninhamento]]** (evitar lógica desnecessariamente encadeada). A conformidade com KISS mantém o [[calculo-icp|ICP]] ≤ 3 para a maioria dos métodos.

## Relacionados

- [[001_single-indentation-level|Nível Único de Indentação]] — reforça
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[005_method-chaining-restriction|Restrição de Encadeamento de Métodos]] — complementa
- [[006_prohibition-abbreviated-names|Proibição de Nomes Abreviados]] — complementa
- [[007_maximum-lines-per-class|Limite Máximo de Linhas por Classe]] — complementa
- [[proibicao-duplicacao-logica]] — complementa
- [[qualidade-comentarios-porque]] — complementa
