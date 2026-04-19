---
name: bracket
description: Convenção para Symbol para métodos privados e contratos. Use ao definir métodos privados em Web Components, ao criar contratos de interface via Symbol, ou ao revisar código que usa nomenclatura baseada em string para privacidade.
model: sonnet
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Bracket

Convenção para Symbol para métodos privados e contratos de interface.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Definição de métodos privados em Web Components; criação de contratos de interface via Symbol para mixins; ao substituir convenções frágeis de privacidade por string (`_method`) |
| **Prerequisites** | Entendimento de JavaScript Symbol (local vs `Symbol.for()` global); estrutura do módulo dono do conceito; skill `anatomy` para posicionamento correto |
| **Constraints** | Não exportar Symbols privados internos; não usar `Symbol.for()` sem necessidade de compartilhamento cross-módulo; Symbol sem descrição é proibido |
| **Scope** | Criação e uso de Symbols para encapsulamento de métodos privados e definição de contratos públicos de interface em Web Components |

---

## Quando Usar

Use ao criar métodos que necessitam decoradores ou ao definir interfaces para mixins.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Encapsulamento | Symbol cria chaves únicas e privadas para métodos e contratos |
| Extensibilidade | Permite definir contratos de interface sem conflito de nomes |

## Regras

| Regra | Descrição |
|-------|-----------|
| Propriedade | O módulo dono do conceito define o Symbol |
| Localidade | Preferir `Symbol()` local sobre `Symbol.for()` global |
| Exportação | Exportar apenas Symbols que sejam contratos públicos |

## Estrutura

| Arquivo | Finalidade |
|---------|-----------|
| `interfaces.js` | Exporta Symbols do módulo |

## Tipos

| Tipo | Sintaxe | Uso |
|------|---------|-----|
| Local | `Symbol('name')` | Privado ao módulo |
| Global | `Symbol.for('name')` | Compartilhado via registro |

## Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-----------|---------|
| Callback | `verbCallback` | `didPaintCallback` |
| Ação | `verbNoun` | `connectArc` |
| Capacidade | `adjective` | `hideable` |
| Recurso | `noun` | `controller` |

## Exemplos

```typescript
// ❌ Bad — privacidade por convenção fraca
class MyComponent extends HTMLElement {
  _privateMethod() { /* não é realmente privado */ }
  __init() { /* convenção frágil */ }
}

// ✅ Good — privacidade via Symbol
const render = Symbol('render')
const init = Symbol('init')

class MyComponent extends HTMLElement {
  [render]() { /* método privado verdadeiro via Symbol */ }
  [init]() { /* acesso controlado */ }
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Usar Symbol.for() desnecessariamente | Symbol local é mais seguro, usar global apenas para contratos cross-módulo |
| Symbol sem descrição | Dificulta debug, sempre passar string descritiva |
| Exportar Symbols privados | Expor apenas contratos de interface pública (rule 013) |
| Nomes genéricos em Symbols | Usar nomes descritivos que revelam intenção (rule 006) |

## Justificativa

- [008 - Proibição de Getters/Setters Puros](../../rules/008_proibicao-getters-setters.md): Symbol permite encapsulamento verdadeiro em vez de getters/setters para acesso a métodos internos
- [013 - Princípio de Segregação de Interfaces](../../rules/013_principio-segregacao-interface.md): contratos específicos via Symbol permitem interfaces granulares e desacopladas
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada Symbol representa um único contrato ou comportamento
