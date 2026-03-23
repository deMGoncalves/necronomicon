---
titulo: Proibição de Nomes Enganosos (Desinformação e Codificação)
aliases:
  - Misleading Names
  - Disinformation
tipo: rule
id: CC-15
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - estrutural
  - nomenclatura
resolver: Antes do commit
relacionados:
  - "[[006_proibicao-nomes-abreviados]]"
  - "[[003_encapsulamento-primitivos]]"
  - "[[nomes-classes-metodos-consistentes]]"
criado: 2025-10-08
---

# Proibição de Nomes Enganosos (Misleading Names)

*Misleading Names / Disinformation*


---

## Definição

Proíbe o uso de nomes que impliquem pistas falsas ou sugiram comportamento que o código não possui (ex.: chamar um `Set` de `accountList`) e proíbe a codificação de tipos nos nomes (ex.: `strName` ou `fValue`).

## Motivação

Nomes enganosos são uma forma de **desinformação** que quebra a confiança do desenvolvedor no código. A *codificação* de tipos (notação húngara) é redundante e polui o código, aumentando o risco de bugs em tempo de execução quando o tipo é alterado.

## Quando Aplicar

- [ ] Variáveis que contêm coleções (`Array`, `Set`, `Map`) devem ser nomeadas de acordo com a estrutura de dados real.
- [ ] É proibido o uso de prefixos de tipo desnecessários nos nomes (ex.: `str`, `int`, `f`).
- [ ] Nomes de variáveis não devem contradizer o tipo de dado que armazenam.

## Quando NÃO Aplicar

- **Interfaces Legadas**: Variáveis onde a notação húngara é exigida para interoperabilidade com código legado ou *frameworks* de baixo nível.

## Violação — Exemplo

```javascript
// ❌ accountList é um Set, não uma List — estrutura de dados enganosa
const accountList = new Set(['alice', 'bob']); // não é uma lista!

// ❌ Notação húngara — tipo no nome (redundante e enganoso se tipo mudar)
const strUserName = 'Alice';
const bIsActive = true;
const nCount = 42;
```

## Conformidade — Exemplo

```javascript
// ✅ Nome reflete a estrutura de dados real
const accountSet = new Set(['alice', 'bob']);
const accounts = ['alice', 'bob']; // lista = plural sem sufixo

// ✅ Sem codificação de tipo — o tipo é autoevidente ou inferido
const userName = 'Alice';
const isActive = true;
const count = 42;
```

## Anti-Patterns Relacionados

- **Disinformation** — nomes que sugerem uma estrutura de dados diferente da real
- **Hungarian Notation** — prefixos de tipo embutidos nos nomes

## Como Detectar

### Manual

Verificar se um nome de variável contradiz seu uso ou o tipo de dado real que contém.

### Automático

Biome: [`useNamingConvention`](https://biomejs.dev/linter/rules/use-naming-convention/) configurado para rejeitar prefixos de tipo húngaro e forçar convenções de coleção.

## Relação com ICP

Impacto indireto: nomes enganosos aumentam o custo cognitivo de auditar o [[calculo-icp|ICP]] — o desenvolvedor gasta energia entendendo o nome antes de conseguir analisar a complexidade real do código.

## Relacionados

- [[006_proibicao-nomes-abreviados|Proibição de Nomes Abreviados]] — complementa
- [[003_encapsulamento-primitivos|Encapsulamento de Primitivos]] — reforça
- [[nomes-classes-metodos-consistentes]] — complementa
