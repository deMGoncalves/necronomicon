---
name: enum
description: Convenção para criação de enums eliminando magic strings/numbers — ao identificar strings ou números repetidos mais de uma vez, criar constantes de domínio, ou revisar código com literais hardcoded em condicionais
model: haiku
allowed-tools: Write, Read, Edit, Glob, Grep
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Enum

Convenção para criação de enums eliminando magic strings/numbers.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao identificar strings ou números literais repetidos 2+ vezes no mesmo módulo ou entre módulos; ao criar constantes de domínio (status, tipos, roles, atributos, eventos) |
| **Prerequisites** | Identificação do módulo proprietário do conceito; rule 024 (Proibição de Constantes Mágicas) como critério de ativação |
| **Constraints** | Enum deve ser congelado com `Object.freeze()`; valor literal único (1 ocorrência) não justifica enum; o módulo proprietário do conceito é o dono do enum |
| **Scope** | Estrutura `Object.freeze({KEY: 'value'})` com nomenclatura `UPPER_SNAKE_CASE`; categorias (Status, Element, Property, Event, Type, Attribute); localização no módulo proprietário |

---

## Quando Usar

Use ao identificar valores literais (strings ou numbers) repetidos mais de 1x.

## Condições

| Condição | Ação |
|----------|------|
| Valor repetido 2+ vezes no mesmo módulo | Criar enum local |
| Valor usado por múltiplos módulos | Criar enum no módulo proprietário e exportar |

## Nomenclatura

| Tipo | Arquivo | Enum | Keys |
|------|---------|------|------|
| Seletores DOM | `element.js` | `Element` | `UPPER_SNAKE_CASE` |
| Propriedades CSS | `property.js` | `Property` | `UPPER_SNAKE_CASE` |
| Eventos | `event.js` | `Event` | `UPPER_SNAKE_CASE` |
| Status/Estados | `status.js` | `Status` | `UPPER_SNAKE_CASE` |
| Tipos/Roles | `type.js` | `Type` | `UPPER_SNAKE_CASE` |
| Atributos | `attribute.js` | `Attribute` | `UPPER_SNAKE_CASE` |

## Regra

| Princípio | Descrição |
|-----------|-------------|
| Propriedade | Módulo que define o conceito é dono do enum |

## Estrutura do Enum

```javascript
export const Status = Object.freeze({
  PENDING: 'pending',
  ACTIVE: 'active',
  COMPLETED: 'completed',
})
```

## Exemplos

```typescript
// ❌ Bad — magic strings e numbers
if (order.status === 'pending') { /* ... */ }
if (user.role === 'admin') { /* ... */ }
const timeout = 3000  // o que esse número significa?

// ✅ Good — enums eliminam ambiguidade
enum OrderStatus { Pending = 'pending', Active = 'active', Cancelled = 'cancelled' }
enum UserRole { Admin = 'admin', Editor = 'editor', Viewer = 'viewer' }
const REQUEST_TIMEOUT_MS = 3000

if (order.status === OrderStatus.Pending) { /* ... */ }
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Valores literais repetidos | Criar enum quando valor aparece 2+ vezes (rule 024) |
| Enum sem Object.freeze | Viola rule 029, enum deve ser imutável |
| Enum com valores não-descritivos | Usar valores que revelam intenção (rule 006) |
| Magic numbers ou magic strings | Substituir por enum nomeado (rule 024) |
| Enum no arquivo errado | Módulo proprietário do conceito define o enum |

## Justificativa

- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): valores literais devem ser constantes nomeadas para rastreabilidade e manutenção
- [029 - Imutabilidade de Objetos](../../rules/029_imutabilidade-objetos-freeze.md): enums devem ser congelados com Object.freeze() para prevenir modificações acidentais em runtime
- [021 - Proibição da Duplicação de Lógica](../../rules/021_proibicao-duplicacao-logica.md): valores não devem ser duplicados, centralizar em enum
