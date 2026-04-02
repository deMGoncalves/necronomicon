---
name: bracket
description: Convenção de Symbol para métodos privados e contratos. Use quando definir métodos privados em Web Components, ao criar contratos de interface via Symbol ou ao revisar código que usa string-based naming para privacidade.
model: sonnet
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Bracket

Convenção de Symbol para métodos privados e contratos de interface.

---

## Quando Usar

Use quando criar métodos que precisam de decorators ou definir interfaces para mixins.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Encapsulamento | Symbol cria chaves únicas e privadas para métodos e contratos |
| Extensibilidade | Permite definir contratos de interface sem conflitos de nomes |

## Regras

| Regra | Descrição |
|-------|-----------|
| Ownership | O módulo dono do conceito define o Symbol |
| Localidade | Preferir `Symbol()` local a `Symbol.for()` global |
| Exportação | Exportar apenas Symbols que são contratos públicos |

## Estrutura

| Arquivo | Propósito |
|---------|-----------|
| `interfaces.js` | Exporta Symbols do módulo |

## Tipos

| Tipo | Sintaxe | Uso |
|------|---------|-----|
| Local | `Symbol('name')` | Privado ao módulo |
| Global | `Symbol.for('name')` | Compartilhado via registry |

## Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-----------|---------|
| Callback | `verbCallback` | `didPaintCallback` |
| Ação | `verbNoun` | `connectArc` |
| Capacidade | `adjective` | `hideable` |
| Recurso | `noun` | `controller` |

## Exemplos

```typescript
// ❌ Ruim — privacidade por convenção fraca
class MyComponent extends HTMLElement {
  _privateMethod() { /* não é realmente privado */ }
  __init() { /* convenção frágil */ }
}

// ✅ Bom — privacidade via Symbol
const render = Symbol('render')
const init = Symbol('init')

class MyComponent extends HTMLElement {
  [render]() { /* método privado real via Symbol */ }
  [init]() { /* acesso controlado */ }
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Usar Symbol.for() sem necessidade | Symbol local é mais seguro, usar global apenas para contratos cross-module |
| Symbol sem descrição | Dificulta debugging, sempre passar string descritiva |
| Exportar Symbols privados | Expor apenas contratos públicos de interface (rule 013) |
| Nomes genéricos em Symbols | Usar nomes descritivos que revelam intenção (rule 006) |

## Fundamentação

- [008 - Proibição de Getters/Setters Puros](../../rules/008_proibicao-getters-setters-puros.md): Symbol permite encapsulamento verdadeiro ao invés de getters/setters para acesso a métodos internos
- [013 - Princípio de Segregação de Interface](../../rules/013_principio-segregacao-interfaces.md): contratos específicos via Symbol permitem interfaces granulares e desacopladas
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada Symbol representa um único contrato ou comportamento
