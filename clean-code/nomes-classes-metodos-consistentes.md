---
titulo: Nomes Consistentes de Classes e Métodos (Funções são Verbos)
aliases:
  - Meaningful Names
  - Functions are Verbs
tipo: rule
id: CC-14
severidade: 🟠 Alto
origem: clean-code
tags:
  - clean-code
  - estrutural
  - nomenclatura
resolver: Sprint atual
relacionados:
  - "[[006_proibicao-nomes-abreviados]]"
  - "[[001_single-responsibility-principle]]"
  - "[[proibicao-nomes-enganosos]]"
criado: 2025-10-08
---

# Nomes Consistentes de Classes e Métodos (Meaningful Names)

*Meaningful Names*


---

## Definição

Requer que nomes de classes sejam **substantivos no singular** (ex.: `User`, `Order`) e que nomes de métodos sejam **verbos ou frases verbais** descrevendo a intenção (ex.: `calculateFee`, `sendNotification`).

## Motivação

A consistência na nomenclatura é fundamental para a **legibilidade** e **previsibilidade** do código. Uma violação quebra o modelo mental do leitor, aumentando o **custo cognitivo** e o risco de interpretar erroneamente a intenção e o sistema de tipos.

## Quando Aplicar

- [ ] Nomes de classes e interfaces devem ser substantivos e usar `PascalCase`.
- [ ] Nomes de métodos públicos devem começar com um verbo (ex.: `get`, `create`, `validate`) e usar `camelCase`.
- [ ] Variáveis que armazenam valores booleanos (predicados) devem usar prefixos claros (ex.: `is`, `has`, `can`).

## Quando NÃO Aplicar

- **Factories/Builders**: Classes com o sufixo `Factory` ou `Builder` são aceitas, pois sua função é estritamente criacional.

## Violação — Exemplo

```javascript
// ❌ Classe nomeada como verbo, método nomeado como substantivo
class DataProcessor { // "Processor" é aceitável mas "Processing" seria verbo — ambíguo
  user(id) { /* retorna usuário? cria? deleta? */ }         // substantivo — ação indefinida
  orderManagement(order) { /* faz o quê? */ }               // substantivo — sem intenção clara
}

let active = true; // booleano sem prefixo — é um estado? uma ação?
```

## Conformidade — Exemplo

```javascript
// ✅ Substantivo para classe, verbos para métodos, prefixos para booleanos
class OrderService {
  findById(id) { /* ... */ }
  createOrder(data) { /* ... */ }
  cancelOrder(orderId) { /* ... */ }
}

const isActive = true;
const hasPermission = user.roles.includes('admin');
const canDelete = isActive && hasPermission;
```

## Anti-Patterns Relacionados

- **Anemic Naming** — nomes vagos como `Manager`, `Handler`, `Helper` que não revelam responsabilidade
- **Hungarian Notation** — prefixos de tipo como `strName`, `intCount`

## Como Detectar

### Manual

Verificar classes terminando em verbos (`Manager`, `Processor`) ou funções com nomes de substantivos (`user`, `order`).

### Automático

Biome: [`useNamingConvention`](https://biomejs.dev/linter/rules/use-naming-convention/) configurado para `PascalCase` em classes e `camelCase` em métodos.

## Relação com ICP

Impacto indireto: nomes que revelam intenção reduzem a necessidade de leitura profunda do código para entender CC e [[componente-responsabilidades|Responsabilidades]]. Código com nomes claros tem [[calculo-icp|ICP]] mais fácil de auditar.

## Relacionados

- [[006_proibicao-nomes-abreviados|Proibição de Nomes Abreviados]] — reforça
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[proibicao-nomes-enganosos]] — complementa
